`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] io_in_0_bits_centeroidIndex;
    reg io_in_0_bits_centeroidsFinished;
    reg [63:0] io_in_0_bits_point_x;
    reg [63:0] io_in_0_bits_point_y;
    reg [63:0] io_in_0_bits_point_z;
    reg io_in_0_bits_pointsFinished;
    reg [9:0] io_in_0_tag;
    reg io_in_0_valid;
    reg io_out_ready;
    reg reset;
    wire io_chosen;
    wire io_in_0_ready;
    wire [15:0] io_out_bits_centeroidIndex;
    wire io_out_bits_centeroidsFinished;
    wire [63:0] io_out_bits_point_x;
    wire [63:0] io_out_bits_point_y;
    wire [63:0] io_out_bits_point_z;
    wire io_out_bits_pointsFinished;
    wire [9:0] io_out_tag;
    wire io_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_in_0_bits_centeroidIndex(io_in_0_bits_centeroidIndex),
        .io_in_0_bits_centeroidsFinished(io_in_0_bits_centeroidsFinished),
        .io_in_0_bits_point_x(io_in_0_bits_point_x),
        .io_in_0_bits_point_y(io_in_0_bits_point_y),
        .io_in_0_bits_point_z(io_in_0_bits_point_z),
        .io_in_0_bits_pointsFinished(io_in_0_bits_pointsFinished),
        .io_in_0_tag(io_in_0_tag),
        .io_in_0_valid(io_in_0_valid),
        .io_out_ready(io_out_ready),
        .reset(reset),
        .io_chosen(io_chosen),
        .io_in_0_ready(io_in_0_ready),
        .io_out_bits_centeroidIndex(io_out_bits_centeroidIndex),
        .io_out_bits_centeroidsFinished(io_out_bits_centeroidsFinished),
        .io_out_bits_point_x(io_out_bits_point_x),
        .io_out_bits_point_y(io_out_bits_point_y),
        .io_out_bits_point_z(io_out_bits_point_z),
        .io_out_bits_pointsFinished(io_out_bits_pointsFinished),
        .io_out_tag(io_out_tag),
        .io_out_valid(io_out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            io_in_0_valid = 0;
            io_out_ready = 0;
            io_in_0_bits_centeroidIndex = 0;
            io_in_0_bits_centeroidsFinished = 0;
            io_in_0_bits_point_x = 0;
            io_in_0_bits_point_y = 0;
            io_in_0_bits_point_z = 0;
            io_in_0_bits_pointsFinished = 0;
            io_in_0_tag = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Pass-through");
            reset_dut();

            io_in_0_valid = 1;
            io_out_ready = 1;
            io_in_0_bits_centeroidIndex = 16'h1234;
            io_in_0_bits_centeroidsFinished = 1;
            io_in_0_bits_point_x = 64'hFEDCBA9876543210;
            io_in_0_bits_point_y = 64'h0123456789ABCDEF;
            io_in_0_bits_point_z = 64'hAAAA_BBBB_CCCC_DDDD;
            io_in_0_bits_pointsFinished = 0;
            io_in_0_tag = 10'h1FF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(
                1'b0,
                1'b1,
                16'h1234,
                1'b1,
                64'hFEDCBA9876543210,
                64'h0123456789ABCDEF,
                64'hAAAA_BBBB_CCCC_DDDD,
                1'b0,
                10'h1FF,
                1'b1
            );
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Backpressure (Ready Low)");
            reset_dut();

            io_in_0_valid = 1;
            io_out_ready = 0;
            io_in_0_bits_centeroidIndex = 16'hAAAA;
            io_in_0_tag = 10'h001;

            @(posedge clk);
            #1;

            #1;


            check_outputs(
                1'b0,
                1'b0,
                16'hAAAA,
                1'b0,
                64'h0,
                64'h0,
                64'h0,
                1'b0,
                10'h001,
                1'b1
            );
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Idle State");
            reset_dut();

            io_in_0_valid = 0;
            io_out_ready = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(
                1'b0,
                1'b1,
                16'h0,
                1'b0,
                64'h0,
                64'h0,
                64'h0,
                1'b0,
                10'h0,
                1'b0
            );
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Maximum Bit Values");
            reset_dut();

            io_in_0_valid = 1;
            io_out_ready = 1;
            io_in_0_bits_centeroidIndex = 16'hFFFF;
            io_in_0_bits_centeroidsFinished = 1;
            io_in_0_bits_point_x = 64'hFFFF_FFFF_FFFF_FFFF;
            io_in_0_bits_point_y = 64'hFFFF_FFFF_FFFF_FFFF;
            io_in_0_bits_point_z = 64'hFFFF_FFFF_FFFF_FFFF;
            io_in_0_bits_pointsFinished = 1;
            io_in_0_tag = 10'h3FF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(
                1'b0,
                1'b1,
                16'hFFFF,
                1'b1,
                64'hFFFF_FFFF_FFFF_FFFF,
                64'hFFFF_FFFF_FFFF_FFFF,
                64'hFFFF_FFFF_FFFF_FFFF,
                1'b1,
                10'h3FF,
                1'b1
            );
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset State Check");
            reset_dut();
            reset = 1;
            io_in_0_valid = 1;

            @(posedge clk);
            #1;


            reset = 0;
            io_in_0_valid = 1;
            io_out_ready = 1;
            io_in_0_tag = 10'h2AA;

            @(posedge clk);
            #1;
            #1;

            check_outputs(
                1'b0, 1'b1, 16'h0, 1'b0, 64'h0, 64'h0, 64'h0, 1'b0, 10'h2AA, 1'b1
            );
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
        input expected_io_chosen;
        input expected_io_in_0_ready;
        input [15:0] expected_io_out_bits_centeroidIndex;
        input expected_io_out_bits_centeroidsFinished;
        input [63:0] expected_io_out_bits_point_x;
        input [63:0] expected_io_out_bits_point_y;
        input [63:0] expected_io_out_bits_point_z;
        input expected_io_out_bits_pointsFinished;
        input [9:0] expected_io_out_tag;
        input expected_io_out_valid;
        begin
            if (expected_io_chosen === (expected_io_chosen ^ io_chosen ^ expected_io_chosen) &&
                expected_io_in_0_ready === (expected_io_in_0_ready ^ io_in_0_ready ^ expected_io_in_0_ready) &&
                expected_io_out_bits_centeroidIndex === (expected_io_out_bits_centeroidIndex ^ io_out_bits_centeroidIndex ^ expected_io_out_bits_centeroidIndex) &&
                expected_io_out_bits_centeroidsFinished === (expected_io_out_bits_centeroidsFinished ^ io_out_bits_centeroidsFinished ^ expected_io_out_bits_centeroidsFinished) &&
                expected_io_out_bits_point_x === (expected_io_out_bits_point_x ^ io_out_bits_point_x ^ expected_io_out_bits_point_x) &&
                expected_io_out_bits_point_y === (expected_io_out_bits_point_y ^ io_out_bits_point_y ^ expected_io_out_bits_point_y) &&
                expected_io_out_bits_point_z === (expected_io_out_bits_point_z ^ io_out_bits_point_z ^ expected_io_out_bits_point_z) &&
                expected_io_out_bits_pointsFinished === (expected_io_out_bits_pointsFinished ^ io_out_bits_pointsFinished ^ expected_io_out_bits_pointsFinished) &&
                expected_io_out_tag === (expected_io_out_tag ^ io_out_tag ^ expected_io_out_tag) &&
                expected_io_out_valid === (expected_io_out_valid ^ io_out_valid ^ expected_io_out_valid)) begin
                $display("PASS");
                $display("  Outputs: io_chosen=%b, io_in_0_ready=%b, io_out_bits_centeroidIndex=%h, io_out_bits_centeroidsFinished=%b, io_out_bits_point_x=%h, io_out_bits_point_y=%h, io_out_bits_point_z=%h, io_out_bits_pointsFinished=%b, io_out_tag=%h, io_out_valid=%b",
                         io_chosen, io_in_0_ready, io_out_bits_centeroidIndex, io_out_bits_centeroidsFinished, io_out_bits_point_x, io_out_bits_point_y, io_out_bits_point_z, io_out_bits_pointsFinished, io_out_tag, io_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_chosen=%b, io_in_0_ready=%b, io_out_bits_centeroidIndex=%h, io_out_bits_centeroidsFinished=%b, io_out_bits_point_x=%h, io_out_bits_point_y=%h, io_out_bits_point_z=%h, io_out_bits_pointsFinished=%b, io_out_tag=%h, io_out_valid=%b",
                         expected_io_chosen, expected_io_in_0_ready, expected_io_out_bits_centeroidIndex, expected_io_out_bits_centeroidsFinished, expected_io_out_bits_point_x, expected_io_out_bits_point_y, expected_io_out_bits_point_z, expected_io_out_bits_pointsFinished, expected_io_out_tag, expected_io_out_valid);
                $display("  Got:      io_chosen=%b, io_in_0_ready=%b, io_out_bits_centeroidIndex=%h, io_out_bits_centeroidsFinished=%b, io_out_bits_point_x=%h, io_out_bits_point_y=%h, io_out_bits_point_z=%h, io_out_bits_pointsFinished=%b, io_out_tag=%h, io_out_valid=%b",
                         io_chosen, io_in_0_ready, io_out_bits_centeroidIndex, io_out_bits_centeroidsFinished, io_out_bits_point_x, io_out_bits_point_y, io_out_bits_point_z, io_out_bits_pointsFinished, io_out_tag, io_out_valid);
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
        $dumpvars(0,clk, io_in_0_bits_centeroidIndex, io_in_0_bits_centeroidsFinished, io_in_0_bits_point_x, io_in_0_bits_point_y, io_in_0_bits_point_z, io_in_0_bits_pointsFinished, io_in_0_tag, io_in_0_valid, io_out_ready, reset, io_chosen, io_in_0_ready, io_out_bits_centeroidIndex, io_out_bits_centeroidsFinished, io_out_bits_point_x, io_out_bits_point_y, io_out_bits_point_z, io_out_bits_pointsFinished, io_out_tag, io_out_valid);
    end

endmodule
