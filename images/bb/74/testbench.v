`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg led_clk;
    reg [7:0] led_in;
    reg led_rst_n;
    wire [7:0] led_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .led_clk(led_clk),
        .led_in(led_in),
        .led_rst_n(led_rst_n),
        .led_out(led_out)
    );

    // Clock generation (10ns period)
    initial begin
        led_clk = 0;
        forever #5 led_clk = ~led_clk;
    end

        task reset_dut;

        begin
            led_rst_n = 0;
            led_in = 8'h00;
            @(posedge led_clk);
            #1 led_rst_n = 1;
            @(posedge led_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase%03d: All inputs low", test_num);
            reset_dut();
            led_in = 8'h00;
            #1;
            #1;

            check_outputs(8'h0C);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase%03d: All inputs high", test_num);
            reset_dut();
            led_in = 8'hFF;
            #1;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase%03d: Partial inputs high", test_num);
            reset_dut();
            led_in = 8'h0F;
            #1;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase%03d: Counter Bit 6 (64 cycles)", test_num);
            reset_dut();
            led_in = 8'h00;
            repeat(63) @(posedge led_clk);
            #1;
            #1;

            check_outputs(8'h1C);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase%03d: Counter Bit 9 (512 cycles)", test_num);
            reset_dut();
            led_in = 8'hFF;
            repeat(511) @(posedge led_clk);
            #1;
            #1;

            check_outputs(8'h83);
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
        input [7:0] expected_led_out;
        begin
            if (expected_led_out === (expected_led_out ^ led_out ^ expected_led_out)) begin
                $display("PASS");
                $display("  Outputs: led_out=%h",
                         led_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_out=%h",
                         expected_led_out);
                $display("  Got:      led_out=%h",
                         led_out);
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
        $dumpvars(0,led_clk, led_in, led_rst_n, led_out);
    end

endmodule
