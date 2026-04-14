`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg actual_outcome;
    reg clk;
    reg reset;
    wire prediction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .actual_outcome(actual_outcome),
        .clk(clk),
        .reset(reset),
        .prediction(prediction)
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
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial state after reset...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: SNT to WNT transition...");
            test_num = 2;
            reset_dut();
            @(posedge clk); #1 actual_outcome = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: WNT to WT transition...");
            test_num = 3;
            reset_dut();
            @(posedge clk); #1 actual_outcome = 1;
            @(posedge clk); #1 actual_outcome = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Transition to Strongly Taken...");
            test_num = 4;
            reset_dut();
            @(posedge clk); #1 actual_outcome = 1;
            @(posedge clk); #1 actual_outcome = 1;
            @(posedge clk); #1 actual_outcome = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Saturation at 11...");
            test_num = 5;
            reset_dut();
            repeat(5) begin
                @(posedge clk); #1 actual_outcome = 1;
            end
            @(posedge clk); #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: ST to WT transition...");
            test_num = 6;
            reset_dut();
            @(posedge clk); #1 actual_outcome = 1;
            @(posedge clk); #1 actual_outcome = 1;
            @(posedge clk); #1 actual_outcome = 1;
            @(posedge clk); #1 actual_outcome = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: WT to WNT transition...");
            test_num = 7;
            reset_dut();
            @(posedge clk); #1 actual_outcome = 1;
            @(posedge clk); #1 actual_outcome = 1;
            @(posedge clk); #1 actual_outcome = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Saturation at 00...");
            test_num = 8;
            reset_dut();
            repeat(3) begin
                @(posedge clk); #1 actual_outcome = 0;
            end
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0);
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
        testcase008();
        
        
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
        $dumpvars(0,actual_outcome, clk, reset, prediction);
    end

endmodule
