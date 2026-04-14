`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg vdd;
    wire rst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vdd(vdd),
        .rst(rst)
    );

    // Clock generation (10ns period)
    initial begin
        vdd = 0;
        forever #5 vdd = ~vdd;
    end

        task reset_dut;

        begin



            #0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying rst is HIGH during the early reset period (t=40ns)", test_num);
            reset_dut();
            #40;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying rst remains HIGH just before the 100ns limit (t=90ns)", test_num);
            reset_dut();
            #50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying rst transitions to LOW after the 100ns limit (t=120ns)", test_num);
            reset_dut();
            #30;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying rst remains LOW consistently (t=250ns)", test_num);
            reset_dut();
            #130;
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
        input expected_rst;
        begin
            if (expected_rst === (expected_rst ^ rst ^ expected_rst)) begin
                $display("PASS");
                $display("  Outputs: rst=%b",
                         rst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rst=%b",
                         expected_rst);
                $display("  Got:      rst=%b",
                         rst);
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
        $dumpvars(0,vdd, rst);
    end

endmodule
