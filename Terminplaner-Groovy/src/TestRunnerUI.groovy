/*
 * Stefan Roock, 2006
 * http://grounit.sourceforge.net
 *
 * Common Public License V1.0
 */
import java.awt.*
import javax.swing.*
import javax.swing.event.*
import groovy.swing.*
import junit.framework.*

class TestRunnerUI {

  TestRunner testRunner = new TestRunner()
  SwingBuilder swing = new SwingBuilder()
  JFrame frame
  def testResults = []
  int failureCount, errorCount, runCount, runMax
  @Property classDir, testName, startButton, stopButton, progress,
            testList, failureList, failureDetails,
            runs, errors, failures, cleanedStrackTrace
  @Property self=this /* Bug GROOVY-1229 */

  static void main(args) {
    def runner = new TestRunnerUI()
    runner.show()
  }

	TestRunnerUI() {
    	frame = swing.frame(title:'Grounit', size:new Dimension(660,600),
      	  defaultCloseOperation:WindowConstants.DISPOSE_ON_CLOSE) {
      		menuBar {
      			menu ('Grounit', mnemonic:'g') {
      				menuItem {action(name:'About...', mnemonic:'a', closure:{ self.showAbout() /* Bug GROOVY-1229 */ })}
      			}
      		}
      		tableLayout {
      			tr { td (colfill:true, align:'center') { self.newInputPanel() /* Bug GROOVY-1229 */ } }
            	tr { td (colfill:true, align:'center') { progress = progressBar() } }
		        tr { td (colfill:true, align:'center') { self.newStatisticsPanel() /* Bug GROOVY-1229 */ } }
				tr { td { label (text:'Tests') } }
		        tr { td (colfill:true, rowfill:true, align:'center') { 
		        		scrollPane (minimumSize:new Dimension(100,100)) {
				        	testList = list(model:new DefaultListModel())
				     	}
				}}
				tr { td { label (text:'Failures') } }
				tr { td (colfill:true, rowfill:true, align:'center') { 
						scrollPane (minimumSize:new Dimension(100,100)) {
				     		failureList = list(model:new DefaultListModel(), 
				        	    valueChanged:{self.showFailureDetails() /* Bug GROOVY-1229 */} )
				     	}
				}}
				tr { td { label (text:'Stacktrace') }
				     td { cleanedStrackTrace = checkBox (text:'Cleaned Stacktrace',
				         actionPerformed:{self.showFailureDetails() /* Bug GROOVY-1229 */} ) } 
				   }
				tr { td (colfill:true, rowfill:true, align:'center') { 
						scrollPane (minimumSize:new Dimension(100,200)) {
				        	failureDetails = textArea(editable:false)
				     	}
			    }}
	        }
	    }
	}

	JPanel newInputPanel() {
  		return swing.panel {
	        panel {
		        label(text:'Class dir')
		        classDir = textField(text:'.', columns:20)
		        label(text:'Test')
		        testName = textField(columns:20)
		        label(text:'.groovy')
		        startButton = button(text:'Run', mnemonic:'r', actionPerformed:{self.startTest() /* Bug GROOVY-1229 */} )
		     //   stopButton = button(text:'Stop', mnemonic:'s', visible:false, enabled:false, actionPerformed:{self.stopTest() /* Bug GROOVY-1229 */} )
	        }        
    	}
	}


	JPanel newStatisticsPanel() {
		return swing.panel {
	        label(text:'Runs:'); runs = label(text:'0')
	        label(text:'Errors:'); errors = label(text:'0')
	        label(text:'Failures:'); failures = label(text:'0')
	    }
    }

	void showAbout() {
	 	def msg = """
	 		Grounit: Unit testing for Groovy
	 		2006, Stefan Roock, stefan.roock@it-agile.de
	 		CPL : Common Public License
	 	"""
		def pane = swing.optionPane(message:msg)
		pane.icon = new ImageIcon('groovy-logo.png')
		def dialog = pane.createDialog(frame, 'About Grounit')
		dialog.show()
	}
			

	void show() {
    	frame.show()
    	frame.toFront()
    	testName.grabFocus()
	}
  
  	void showFailureDetails() {
		failureDetails.text = ""
    	failureDetails.caretPosition = 0
    	if (failureList.isSelectionEmpty()) return
  	    def failure = failureList.selectedValue
    	def failureStackTrace = testRunner.cleanStackTrace(failure, cleanedStrackTrace.selected)
    	failureDetails.text = "${failure} \n ${failureStackTrace}"
  	}
  
  	void startTest() {
	    testList.model.clear()
	    failureList.model.clear()
	    def tests = testRunner.collectFilesToTest(classDir.text, testName.text)
	    runMax = tests.size()
	    progress.maximum = runMax  
	    progress.value = 0
	    tests.each() { runOneTest(it) }
    }
  
  void runOneTest(File file) {
    println 'Run: ' + file
    def shell = new GroovyShell()
    def result = shell.run(file, GroovyShell.EMPTY_ARGS)
    testList.model.addElement(file.name)
    processTestResult(result)
    updateUI()
  }
  
  void processTestResult(TestResult result) {
    testResults += result
    runCount++
    failureCount += result.failureCount()
    errorCount += result.errorCount()
    runCount += result.runCount()
    result.errors().each() {failureList.model.addElement(it)}
    result.failures().each() {failureList.model.addElement(it)}
  }


  void updateUI() {
    failures.text = failureCount
    errors.text = errorCount
    runs.text = "${runCount}"
    progress.setValue(runCount)
  }

  void stopTest() {
    println('Stop')
  }

}

class TestRunner {

	final START_OF_REAL_STACKTRACE_AFTER = "ScriptBytecodeAdapter"

	def collectFilesToTest(String classDir, String testName) {
	    if (testName.size() > 0) {
		    def fileName = classDir.text + '/' + testName.replaceAll('\\.','/') + '.groovy'
		    println 'Test: ' + fileName
		    def file = new java.io.File(fileName)
		    assert file.isFile()
		    return [file]
	    }
	    else {
	      def result = []
	      new File(classDir).eachFileRecurse() { if(isTestCase(it)) result += it }
	      return result
	    }
	}
  
    Boolean isTestCase(File file) {
    	return file.isFile() && file.name.endsWith('Test.groovy')
  	}
  
  
	String cleanStackTrace(TestFailure failure,  Boolean clean) {
	  	StackTraceElement[] stackTrace = failure.thrownException().stackTrace
	  	def stopIndex = stackTrace.length-1
	    def result = ""
	    Boolean startNow = false
	    for (element in stackTrace) {
	    	if (clean && element.toString().indexOf(START_OF_REAL_STACKTRACE_AFTER) >= 0) {
	    	  startNow = true
	    	}
	    	else if (!clean || startNow) {
	    		result += "\n ${element}"
	    	}
	    }
	    return result
	}

}

