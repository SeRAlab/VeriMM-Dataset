`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg branch_outcome;
    reg clk;
    reg rst;
    wire prediction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .branch_outcome(branch_outcome),
        .clk(clk),
        .rst(rst),
        .prediction(prediction)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            branch_outcome = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial prediction after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Two consecutive Taken outcomes (00 -> 01 -> 10)", test_num);
            reset_dut();
            branch_outcome = 1; @(posedge clk);
            #1;
            branch_outcome = 1; @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Upper saturation (Three Taken outcomes: 00 -> 01 -> 10 -> 11)", test_num);
            reset_dut();
            branch_outcome = 1; @(posedge clk);
            #1;
            branch_outcome = 1; @(posedge clk);
            #1;
            branch_outcome = 1; @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hysteresis (ST -> WT)", test_num);
            reset_dut();

            branch_outcome = 1; @(posedge clk);
            #1;
            branch_outcome = 1; @(posedge clk);
            #1;
            branch_outcome = 1; @(posedge clk);
            #1;

            branch_outcome = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Prediction flip (ST -> WT -> WNT)", test_num);
            reset_dut();

            branch_outcome = 1; @(posedge clk);
            #1;
            branch_outcome = 1; @(posedge clk);
            #1;
            branch_outcome = 1; @(posedge clk);
            #1;

            branch_outcome = 0; @(posedge clk);
            #1;
            branch_outcome = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Lower saturation (Multiple Not Taken outcomes)", test_num);
            reset_dut();
            branch_outcome = 0; @(posedge clk);
            #1;
            branch_outcome = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Fluctuating outcomes (T, T, NT, T)", test_num);
            reset_dut();
            branch_outcome = 1; @(posedge clk);
            #1;
            branch_outcome = 1; @(posedge clk);
            #1;
            branch_outcome = 0; @(posedge clk);
            #1;
            branch_outcome = 1; @(posedge clk);
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
        testcase006();
        testcase007();
        
        
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
        input expected_prediction;
        begin
            if (expected_prediction === (expected_prediction ^ prediction ^ expected_prediction)) begin
                $display("PASS");
                $display("  Outputs: prediction=%b",
                         prediction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prediction=%b",
                         expected_prediction);
                $display("  Got:      prediction=%b",
                         prediction);
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
        $dumpvars(0,branch_outcome, clk, rst, prediction);
    end

endmodule
