`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_100mhz;
    reg rst_100mhz;
    wire out_1hz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_100mhz(clk_100mhz),
        .rst_100mhz(rst_100mhz),
        .out_1hz(out_1hz)
    );

    // Clock generation (10ns period)
    initial begin
        clk_100mhz = 0;
        forever #5 clk_100mhz = ~clk_100mhz;
    end

        task reset_dut;

        begin
            rst_100mhz = 1;
            #20;
            rst_100mhz = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();
            @(posedge clk_100mhz);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Stability after Reset (short duration)", test_num);
            reset_dut();
            repeat (10000) @(posedge clk_100mhz);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Asynchronous Reset Assertion", test_num);
            reset_dut();
            repeat (100) @(posedge clk_100mhz);

            #3;
            rst_100mhz = 1;
            #2;
            #1;

            check_outputs(1'b0);
            #10;
            rst_100mhz = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Extended Operation (within 1ms limit)", test_num);
            reset_dut();

            repeat (90000) @(posedge clk_100mhz);
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
        input expected_out_1hz;
        begin
            if (expected_out_1hz === (expected_out_1hz ^ out_1hz ^ expected_out_1hz)) begin
                $display("PASS");
                $display("  Outputs: out_1hz=%b",
                         out_1hz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_1hz=%b",
                         expected_out_1hz);
                $display("  Got:      out_1hz=%b",
                         out_1hz);
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
        $dumpvars(0,clk_100mhz, rst_100mhz, out_1hz);
    end

endmodule
