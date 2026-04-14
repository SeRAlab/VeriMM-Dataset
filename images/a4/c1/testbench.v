`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_enable;
    reg [1:0] i_wr_rdy;
    reg [23:0] i_wr_size;
    reg rst;
    wire [1:0] o_wr_act;
    wire [31:0] o_wr_data;
    wire o_wr_stb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_enable(i_enable),
        .i_wr_rdy(i_wr_rdy),
        .i_wr_size(i_wr_size),
        .rst(rst),
        .o_wr_act(o_wr_act),
        .o_wr_data(o_wr_data),
        .o_wr_stb(o_wr_stb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            i_enable = 0;
            i_wr_rdy = 2'b00;
            i_wr_size = 24'd0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State");
            reset_dut();
            #1;

            check_outputs(2'b00, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Channel 0 Write (Size 5)");
            reset_dut();
            i_wr_size = 24'd5;
            i_wr_rdy = 2'b01;
            i_enable = 1;
            @(posedge clk);

            wait(o_wr_act == 2'b01);
            wait(o_wr_act == 2'b00);
            #1;
            #1;

            check_outputs(2'b00, 32'd5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Channel 1 Write (Size 3)");
            reset_dut();
            i_wr_size = 24'd3;
            i_wr_rdy = 2'b10;
            i_enable = 1;
            @(posedge clk);
            wait(o_wr_act == 2'b10);
            wait(o_wr_act == 2'b00);
            #1;
            #1;

            check_outputs(2'b00, 32'd3, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enable Gating Check");
            reset_dut();
            i_wr_size = 24'd10;
            i_wr_rdy = 2'b11;
            i_enable = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(2'b00, 32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Minimum Size (1)");
            reset_dut();
            i_wr_size = 24'd1;
            i_wr_rdy = 2'b01;
            i_enable = 1;
            @(posedge clk);
            wait(o_wr_act == 2'b01);
            wait(o_wr_act == 2'b00);
            #1;
            #1;

            check_outputs(2'b00, 32'd1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Ping-Pong Sequence");
            reset_dut();
            i_wr_size = 24'd2;
            i_wr_rdy = 2'b01;
            i_enable = 1;
            @(posedge clk);
            wait(o_wr_act == 2'b00);

            i_wr_rdy = 2'b10;
            @(posedge clk);
            wait(o_wr_act == 2'b10);
            wait(o_wr_act == 2'b00);
            #1;
            #1;

            check_outputs(2'b00, 32'd2, 1'b0);
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
        input [1:0] expected_o_wr_act;
        input [31:0] expected_o_wr_data;
        input expected_o_wr_stb;
        begin
            if (expected_o_wr_act === (expected_o_wr_act ^ o_wr_act ^ expected_o_wr_act) &&
                expected_o_wr_data === (expected_o_wr_data ^ o_wr_data ^ expected_o_wr_data) &&
                expected_o_wr_stb === (expected_o_wr_stb ^ o_wr_stb ^ expected_o_wr_stb)) begin
                $display("PASS");
                $display("  Outputs: o_wr_act=%h, o_wr_data=%h, o_wr_stb=%b",
                         o_wr_act, o_wr_data, o_wr_stb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_wr_act=%h, o_wr_data=%h, o_wr_stb=%b",
                         expected_o_wr_act, expected_o_wr_data, expected_o_wr_stb);
                $display("  Got:      o_wr_act=%h, o_wr_data=%h, o_wr_stb=%b",
                         o_wr_act, o_wr_data, o_wr_stb);
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
        $dumpvars(0,clk, i_enable, i_wr_rdy, i_wr_size, rst, o_wr_act, o_wr_data, o_wr_stb);
    end

endmodule
