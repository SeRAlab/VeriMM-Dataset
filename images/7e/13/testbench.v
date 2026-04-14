`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg INIT_CLK;
    wire INIT_CLK_O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .INIT_CLK(INIT_CLK),
        .INIT_CLK_O(INIT_CLK_O)
    );

    // Clock generation (10ns period)
    initial begin
        INIT_CLK = 0;
        forever #5 INIT_CLK = ~INIT_CLK;
    end

        task reset_dut;

        begin


            @(posedge INIT_CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase%03d: Initial state check...", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase%03d: First delayed high phase check...", test_num);
            reset_dut();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase%03d: Second delayed low phase check...", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase%03d: Second delayed high phase check...", test_num);
            reset_dut();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running testcase%03d: Steady state low phase check...", test_num);
            reset_dut();
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
        $display("top_module Testbench");
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
        input expected_INIT_CLK_O;
        begin
            if (expected_INIT_CLK_O === (expected_INIT_CLK_O ^ INIT_CLK_O ^ expected_INIT_CLK_O)) begin
                $display("PASS");
                $display("  Outputs: INIT_CLK_O=%b",
                         INIT_CLK_O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: INIT_CLK_O=%b",
                         expected_INIT_CLK_O);
                $display("  Got:      INIT_CLK_O=%b",
                         INIT_CLK_O);
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
        $dumpvars(0,INIT_CLK, INIT_CLK_O);
    end

endmodule
