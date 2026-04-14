`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg sys_clk;
    reg sys_rst_n;
    wire [3:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .led(led)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            sys_rst_n = 1'b1;
            #10;
            sys_rst_n = 1'b0;
            #20;
            sys_rst_n = 1'b1;
            @(posedge sys_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            repeat (SHIFT_CYCLES) @(posedge sys_clk);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            repeat (2 * SHIFT_CYCLES) @(posedge sys_clk);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            repeat (3 * SHIFT_CYCLES) @(posedge sys_clk);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            repeat (4 * SHIFT_CYCLES) @(posedge sys_clk);
            #1;

            check_outputs(4'b0001);
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
        input [3:0] expected_led;
        begin
            if (expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: led=%h",
                         led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h",
                         expected_led);
                $display("  Got:      led=%h",
                         led);
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
        $dumpvars(0,sys_clk, sys_rst_n, led);
    end

endmodule
