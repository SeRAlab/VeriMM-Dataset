`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [2:0] color_in;
    reg enable;
    reg ld_c;
    reg ld_x;
    reg ld_y;
    reg [6:0] position;
    reg reset;
    wire [2:0] color_out;
    wire [7:0] x_out;
    wire [6:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .color_in(color_in),
        .enable(enable),
        .ld_c(ld_c),
        .ld_x(ld_x),
        .ld_y(ld_y),
        .position(position),
        .reset(reset),
        .color_out(color_out),
        .x_out(x_out),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 0;
        enable = 0;
        ld_x = 0;
        ld_y = 0;
        ld_c = 0;
        position = 7'd0;
        color_in = 3'd0;
        @(negedge clock);
        reset = 0;
        @(negedge clock);
        reset = 1;
        @(negedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Running Testcase 001: Basic Load and Output...");

        position = 7'd45; ld_x = 1; @(negedge clock);
        ld_x = 0; position = 7'd32; ld_y = 1; @(negedge clock);
        ld_y = 0; color_in = 3'd6; ld_c = 1; @(negedge clock);
        ld_c = 0;


        #1;



        check_outputs(3'd6, 8'd45, 7'd32);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Running Testcase 002: Index Increment (X-axis offset)...");

        position = 7'd10; ld_x = 1; @(negedge clock);
        ld_x = 0; position = 7'd20; ld_y = 1; @(negedge clock);
        ld_y = 0; color_in = 3'd2; ld_c = 1; @(negedge clock);
        ld_c = 0;

        enable = 1; @(negedge clock);
        enable = 0;


        #1;



        check_outputs(3'd2, 8'd11, 7'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Running Testcase 003: Index Wrapping (Y-axis offset)...");

        position = 7'd10; ld_x = 1; @(negedge clock);
        ld_x = 0; position = 7'd20; ld_y = 1; @(negedge clock);
        ld_y = 0; color_in = 3'd3; ld_c = 1; @(negedge clock);
        ld_c = 0;

        enable = 1; repeat(4) @(negedge clock);
        enable = 0;


        #1;



        check_outputs(3'd3, 8'd10, 7'd21);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Running Testcase 004: Maximum Index Offset (15 cycles)...");

        position = 7'd50; ld_x = 1; @(negedge clock);
        ld_x = 0; position = 7'd50; ld_y = 1; @(negedge clock);
        ld_y = 0; color_in = 3'd7; ld_c = 1; @(negedge clock);
        ld_c = 0;

        enable = 1; repeat(15) @(negedge clock);
        enable = 0;


        #1;



        check_outputs(3'd7, 8'd53, 7'd53);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Running Testcase 005: Load Enable Signal Integrity...");


        position = 7'd100; ld_x = 1; @(negedge clock);
        ld_x = 0; position = 7'd80; ld_y = 1; @(negedge clock);
        ld_y = 0; color_in = 3'd1; ld_c = 1; @(negedge clock);
        ld_c = 0;


        position = 7'd20; color_in = 3'd5; @(negedge clock);


        #1;



        check_outputs(3'd1, 8'd100, 7'd80);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase 006: Reset Initialization...");


        position = 7'd10; ld_x = 1; @(negedge clock);


        reset = 0;
        @(negedge clock);


        #1;



        check_outputs(3'd0, 8'd0, 7'd0);
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
        input [2:0] expected_color_out;
        input [7:0] expected_x_out;
        input [6:0] expected_y_out;
        begin
            if (expected_color_out === (expected_color_out ^ color_out ^ expected_color_out) &&
                expected_x_out === (expected_x_out ^ x_out ^ expected_x_out) &&
                expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: color_out=%h, x_out=%h, y_out=%h",
                         color_out, x_out, y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: color_out=%h, x_out=%h, y_out=%h",
                         expected_color_out, expected_x_out, expected_y_out);
                $display("  Got:      color_out=%h, x_out=%h, y_out=%h",
                         color_out, x_out, y_out);
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
        $dumpvars(0,clock, color_in, enable, ld_c, ld_x, ld_y, position, reset, color_out, x_out, y_out);
    end

endmodule
