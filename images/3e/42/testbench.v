`timescale 1ns/1ps

module branch_predictor_tb;

    // Testbench signals (sequential circuit)
    reg actual_outcome;
    reg branch_signal;
    reg clk;
    reg reset;
    wire taken;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    branch_predictor dut (
        .actual_outcome(actual_outcome),
        .branch_signal(branch_signal),
        .clk(clk),
        .reset(reset),
        .taken(taken)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            branch_signal = 0;
            actual_outcome = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state check...");
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: SNT to WNT transition...");
            reset_dut();
            branch_signal = 1;
            actual_outcome = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Transition to Weakly Taken...");
            reset_dut();
            branch_signal = 1;
            actual_outcome = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Transition to Strongly Taken...");
            reset_dut();
            branch_signal = 1;
            actual_outcome = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Upper saturation check...");
            reset_dut();
            branch_signal = 1;
            actual_outcome = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: ST to WT transition...");
            reset_dut();
            branch_signal = 1;
            actual_outcome = 1;
            repeat(3) @(posedge clk);
            actual_outcome = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: ST to WNT transition...");
            reset_dut();
            branch_signal = 1;
            actual_outcome = 1;
            repeat(3) @(posedge clk);
            actual_outcome = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Lower saturation check...");
            reset_dut();
            branch_signal = 1;
            actual_outcome = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: branch_signal logic check...");
            reset_dut();
            branch_signal = 0;
            actual_outcome = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Running testcase010: Complex sequence check...");
            reset_dut();
            branch_signal = 1;

            actual_outcome = 1; @(posedge clk);
            actual_outcome = 1; @(posedge clk);
            actual_outcome = 0; @(posedge clk);
            actual_outcome = 1; @(posedge clk);
            actual_outcome = 1; @(posedge clk);

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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_taken;
        begin
            if (expected_taken === (expected_taken ^ taken ^ expected_taken)) begin
                $display("PASS");
                $display("  Outputs: taken=%b",
                         taken);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: taken=%b",
                         expected_taken);
                $display("  Got:      taken=%b",
                         taken);
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
        $dumpvars(0,actual_outcome, branch_signal, clk, reset, taken);
    end

endmodule
