`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg actual_outcome;
    reg clk;
    reg reset;
    wire prediction_correct;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .actual_outcome(actual_outcome),
        .clk(clk),
        .reset(reset),
        .prediction_correct(prediction_correct)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        actual_outcome = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: WNT to WT Transition", test_num);
        reset_dut();


        actual_outcome = 1;
        @(posedge clk);
        #1;

        actual_outcome = 1;
        #1 #1;
 check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Saturation at Strongly Not Taken", test_num);
        reset_dut();

        actual_outcome = 0;
        @(posedge clk);
        #1;

        actual_outcome = 0;
        @(posedge clk);
        #1;

        actual_outcome = 0;
        #1 #1;
 check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hysteresis - SNT to WT", test_num);
        reset_dut();

        actual_outcome = 0; @(posedge clk); #1;


        actual_outcome = 1; @(posedge clk); #1;


        actual_outcome = 1;
        #1 #1;
 check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Saturation at Strongly Taken", test_num);
        reset_dut();

        actual_outcome = 1; @(posedge clk); #1;
        actual_outcome = 1; @(posedge clk); #1;


        actual_outcome = 1;
        #1 #1;
 check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Oscillating Outcomes", test_num);
        reset_dut();

        actual_outcome = 1; @(posedge clk); #1;
        actual_outcome = 0; @(posedge clk); #1;
        actual_outcome = 1; @(posedge clk); #1;
        actual_outcome = 0; @(posedge clk); #1;


        actual_outcome = 1;
        #1 #1;
 check_outputs(0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("branch_predictor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_prediction_correct;
        begin
            if (expected_prediction_correct === (expected_prediction_correct ^ prediction_correct ^ expected_prediction_correct)) begin
                $display("PASS");
                $display("  Outputs: prediction_correct=%b",
                         prediction_correct);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prediction_correct=%b",
                         expected_prediction_correct);
                $display("  Got:      prediction_correct=%b",
                         prediction_correct);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,actual_outcome, clk, reset, prediction_correct);
    end

endmodule
