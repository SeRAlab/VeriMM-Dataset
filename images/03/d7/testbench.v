`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg actual_outcome;
    reg clk;
    reg rst;
    wire predicted_outcome;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .actual_outcome(actual_outcome),
        .clk(clk),
        .rst(rst),
        .predicted_outcome(predicted_outcome)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        actual_outcome = 0;
        @(negedge clk);
        rst = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Check initial state after reset (Default 0)", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Actual outcome Taken (1) -> Predict Taken (1)", test_num);
        reset_dut();
        actual_outcome = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Actual outcome Not Taken (0) -> Predict Not Taken (0)", test_num);
        reset_dut();
        actual_outcome = 1;
        @(posedge clk);
        actual_outcome = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sequence Taken -> Not Taken -> Check Prediction", test_num);
        reset_dut();
        actual_outcome = 1;
        @(posedge clk);
        actual_outcome = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sequence Not Taken -> Taken -> Check Prediction", test_num);
        reset_dut();
        actual_outcome = 0;
        @(posedge clk);
        actual_outcome = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
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
        input expected_predicted_outcome;
        begin
            if (expected_predicted_outcome === (expected_predicted_outcome ^ predicted_outcome ^ expected_predicted_outcome)) begin
                $display("PASS");
                $display("  Outputs: predicted_outcome=%b",
                         predicted_outcome);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: predicted_outcome=%b",
                         expected_predicted_outcome);
                $display("  Got:      predicted_outcome=%b",
                         predicted_outcome);
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
        $dumpvars(0,actual_outcome, clk, rst, predicted_outcome);
    end

endmodule
