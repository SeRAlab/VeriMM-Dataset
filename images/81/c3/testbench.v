`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] pixel_data_in;
    reg pixel_en_in;
    reg [1:0] pixel_info_in;
    reg reset;
    wire [15:0] pixel_data_out;
    wire pixel_en_out;
    wire [1:0] pixel_info_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pixel_data_in(pixel_data_in),
        .pixel_en_in(pixel_en_in),
        .pixel_info_in(pixel_info_in),
        .reset(reset),
        .pixel_data_out(pixel_data_out),
        .pixel_en_out(pixel_en_out),
        .pixel_info_out(pixel_info_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        pixel_data_in = 16'h0;
        pixel_en_in = 0;
        pixel_info_in = 2'b0;
        repeat(5) @(posedge clk);
        reset = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Reset Verification");
        #1;

        check_outputs(16'h0000, 1'b0, 2'b00);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: First Pixel Passing");
        pixel_data_in = 16'hA5A5;
        pixel_info_in = 2'b01;
        pixel_en_in = 1'b1;
        @(posedge clk);
        pixel_en_in = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(16'hA5A5, 1'b1, 2'b01);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Second Pixel Dropping");

        pixel_data_in = 16'h1111;
        pixel_info_in = 2'b01;
        pixel_en_in = 1'b1;
        @(posedge clk);

        pixel_data_in = 16'h2222;
        pixel_info_in = 2'b10;
        pixel_en_in = 1'b1;
        @(posedge clk);
        pixel_en_in = 1'b0;
        @(posedge clk);

        #1;


        check_outputs(16'h2222, 1'b0, 2'b10);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Third Pixel Passing");

        pixel_en_in = 1'b1;
        @(posedge clk);

        pixel_en_in = 1'b1;
        @(posedge clk);

        pixel_data_in = 16'h3333;
        pixel_info_in = 2'b11;
        pixel_en_in = 1'b1;
        @(posedge clk);
        pixel_en_in = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(16'h3333, 1'b1, 2'b11);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Gaps in Input Enable");

        pixel_en_in = 1'b1;
        @(posedge clk);

        pixel_en_in = 1'b0;
        repeat(3) @(posedge clk);

        pixel_data_in = 16'h4444;
        pixel_info_in = 2'b00;
        pixel_en_in = 1'b1;
        @(posedge clk);
        pixel_en_in = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(16'h4444, 1'b0, 2'b00);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase 006: Reset Mid-stream");

        pixel_en_in = 1'b1;
        @(posedge clk);

        reset = 0;
        @(posedge clk);
        reset = 1;
        pixel_data_in = 16'h5555;
        pixel_info_in = 2'b10;
        pixel_en_in = 1'b1;
        @(posedge clk);
        pixel_en_in = 1'b0;
        @(posedge clk);

        #1;


        check_outputs(16'h5555, 1'b1, 2'b10);
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
        input [15:0] expected_pixel_data_out;
        input expected_pixel_en_out;
        input [1:0] expected_pixel_info_out;
        begin
            if (expected_pixel_data_out === (expected_pixel_data_out ^ pixel_data_out ^ expected_pixel_data_out) &&
                expected_pixel_en_out === (expected_pixel_en_out ^ pixel_en_out ^ expected_pixel_en_out) &&
                expected_pixel_info_out === (expected_pixel_info_out ^ pixel_info_out ^ expected_pixel_info_out)) begin
                $display("PASS");
                $display("  Outputs: pixel_data_out=%h, pixel_en_out=%b, pixel_info_out=%h",
                         pixel_data_out, pixel_en_out, pixel_info_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel_data_out=%h, pixel_en_out=%b, pixel_info_out=%h",
                         expected_pixel_data_out, expected_pixel_en_out, expected_pixel_info_out);
                $display("  Got:      pixel_data_out=%h, pixel_en_out=%b, pixel_info_out=%h",
                         pixel_data_out, pixel_en_out, pixel_info_out);
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
        $dumpvars(0,clk, pixel_data_in, pixel_en_in, pixel_info_in, reset, pixel_data_out, pixel_en_out, pixel_info_out);
    end

endmodule
