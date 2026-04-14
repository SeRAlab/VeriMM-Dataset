`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg actual_outcome;
    reg clk;
    reg reset;
    wire predicted_outcome;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .actual_outcome(actual_outcome),
        .clk(clk),
        .reset(reset),
        .predicted_outcome(predicted_outcome)
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
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase001: SNT -> WNT -> WT transition...");
            reset_dut();
            actual_outcome = 1;
            @(posedge clk);
            #1;
            actual_outcome = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase002: Saturating at Strongly Taken...");
            reset_dut();
            actual_outcome = 1;
            repeat(4) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase003: ST -> WT -> WNT transition...");
            reset_dut();

            actual_outcome = 1;
            repeat(3) @(posedge clk);
            #1;

            actual_outcome = 0;
            @(posedge clk);
            #1;
            actual_outcome = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase004: Saturating at Strongly Not Taken...");
            reset_dut();
            actual_outcome = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase005: Hysteresis check (ST -> WT)...");
            reset_dut();
            actual_outcome = 1;
            repeat(3) @(posedge clk);
            #1;
            actual_outcome = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase006: Alternating outcomes...");
            reset_dut();
            repeat(2) begin
                actual_outcome = 1; @(posedge clk); #1;
                actual_outcome = 0; @(posedge clk); #1;
            end
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
        $dumpvars(0,actual_outcome, clk, reset, predicted_outcome);
    end

endmodule
