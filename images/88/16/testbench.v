`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg div_clock;
    reg reset;
    wire enable_cuenta;
    wire [3:0] estado;
    wire led_read;
    wire led_write;
    wire read_value_reg_en;
    wire write_enable;
    wire write_value_reg_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .div_clock(div_clock),
        .reset(reset),
        .enable_cuenta(enable_cuenta),
        .estado(estado),
        .led_read(led_read),
        .led_write(led_write),
        .read_value_reg_en(read_value_reg_en),
        .write_enable(write_enable),
        .write_value_reg_en(write_value_reg_en)
    );

    // Clock generation (10ns period)
    initial begin
        div_clock = 0;
        forever #5 div_clock = ~div_clock;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge div_clock);
            #2 reset = 0;

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Check STATE_0 after Reset");
            reset_dut();

            #1;


            check_outputs(1'b0, 4'd0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Check transition to STATE_1");
            reset_dut();
            @(posedge div_clock);
            #1;

            #1;


            check_outputs(1'b0, 4'd1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Check transition to STATE_2");
            reset_dut();
            repeat(2) @(posedge div_clock);
            #1;

            #1;


            check_outputs(1'b0, 4'd2, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Check transition to STATE_3");
            reset_dut();
            repeat(3) @(posedge div_clock);
            #1;

            #1;


            check_outputs(1'b0, 4'd3, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Check transition to STATE_4");
            reset_dut();
            repeat(4) @(posedge div_clock);
            #1;

            #1;


            check_outputs(1'b1, 4'd4, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Check wrap-around back to STATE_0");
            reset_dut();
            repeat(5) @(posedge div_clock);
            #1;

            #1;


            check_outputs(1'b0, 4'd0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Check multiple loop iterations (Cycle to STATE_1)");
            reset_dut();
            repeat(6) @(posedge div_clock);
            #1;

            #1;


            check_outputs(1'b0, 4'd1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Check Reset during STATE_3");
            reset_dut();
            repeat(3) @(posedge div_clock);
            reset = 1;
            @(posedge div_clock);
            #2 reset = 0;
            #1;

            #1;


            check_outputs(1'b0, 4'd0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
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
        input expected_enable_cuenta;
        input [3:0] expected_estado;
        input expected_led_read;
        input expected_led_write;
        input expected_read_value_reg_en;
        input expected_write_enable;
        input expected_write_value_reg_en;
        begin
            if (expected_enable_cuenta === (expected_enable_cuenta ^ enable_cuenta ^ expected_enable_cuenta) &&
                expected_estado === (expected_estado ^ estado ^ expected_estado) &&
                expected_led_read === (expected_led_read ^ led_read ^ expected_led_read) &&
                expected_led_write === (expected_led_write ^ led_write ^ expected_led_write) &&
                expected_read_value_reg_en === (expected_read_value_reg_en ^ read_value_reg_en ^ expected_read_value_reg_en) &&
                expected_write_enable === (expected_write_enable ^ write_enable ^ expected_write_enable) &&
                expected_write_value_reg_en === (expected_write_value_reg_en ^ write_value_reg_en ^ expected_write_value_reg_en)) begin
                $display("PASS");
                $display("  Outputs: enable_cuenta=%b, estado=%h, led_read=%b, led_write=%b, read_value_reg_en=%b, write_enable=%b, write_value_reg_en=%b",
                         enable_cuenta, estado, led_read, led_write, read_value_reg_en, write_enable, write_value_reg_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enable_cuenta=%b, estado=%h, led_read=%b, led_write=%b, read_value_reg_en=%b, write_enable=%b, write_value_reg_en=%b",
                         expected_enable_cuenta, expected_estado, expected_led_read, expected_led_write, expected_read_value_reg_en, expected_write_enable, expected_write_value_reg_en);
                $display("  Got:      enable_cuenta=%b, estado=%h, led_read=%b, led_write=%b, read_value_reg_en=%b, write_enable=%b, write_value_reg_en=%b",
                         enable_cuenta, estado, led_read, led_write, read_value_reg_en, write_enable, write_value_reg_en);
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
        $dumpvars(0,div_clock, reset, enable_cuenta, estado, led_read, led_write, read_value_reg_en, write_enable, write_value_reg_en);
    end

endmodule
