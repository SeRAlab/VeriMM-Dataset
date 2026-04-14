`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK_50;
    wire CLOCK_25;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK_50(CLOCK_50),
        .CLOCK_25(CLOCK_25)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK_50 = 0;
        forever #5 CLOCK_50 = ~CLOCK_50;
    end

        task reset_dut;

        begin


            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sampling after 1st rising edge (Expected: 1)", test_num);
            reset_dut();
            @(posedge CLOCK_50);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sampling after 2nd rising edge (Expected: 0)", test_num);
            reset_dut();
            @(posedge CLOCK_50);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sampling after 3rd rising edge (Expected: 1)", test_num);
            reset_dut();
            @(posedge CLOCK_50);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sampling after 4th rising edge (Expected: 0)", test_num);
            reset_dut();
            @(posedge CLOCK_50);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sampling after 10th rising edge (Expected: 0)", test_num);
            reset_dut();

            repeat(6) @(posedge CLOCK_50);
            #1;
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
        input expected_CLOCK_25;
        begin
            if (expected_CLOCK_25 === (expected_CLOCK_25 ^ CLOCK_25 ^ expected_CLOCK_25)) begin
                $display("PASS");
                $display("  Outputs: CLOCK_25=%b",
                         CLOCK_25);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLOCK_25=%b",
                         expected_CLOCK_25);
                $display("  Got:      CLOCK_25=%b",
                         CLOCK_25);
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
        $dumpvars(0,CLOCK_50, CLOCK_25);
    end

endmodule
