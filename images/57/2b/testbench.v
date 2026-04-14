`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_pixel_stb;
    reg [24:0] i_read_data;
    reg i_read_rdy;
    reg [23:0] i_read_size;
    reg i_tp_blue;
    reg i_tp_green;
    reg i_tp_red;
    reg rst;
    wire [7:0] o_blue;
    wire [7:0] o_green;
    wire o_last;
    wire o_pixel_rdy;
    wire o_read_act;
    wire o_read_stb;
    wire [7:0] o_red;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_pixel_stb(i_pixel_stb),
        .i_read_data(i_read_data),
        .i_read_rdy(i_read_rdy),
        .i_read_size(i_read_size),
        .i_tp_blue(i_tp_blue),
        .i_tp_green(i_tp_green),
        .i_tp_red(i_tp_red),
        .rst(rst),
        .o_blue(o_blue),
        .o_green(o_green),
        .o_last(o_last),
        .o_pixel_rdy(o_pixel_rdy),
        .o_read_act(o_read_act),
        .o_read_stb(o_read_stb),
        .o_red(o_red)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            i_pixel_stb = 0;
            i_read_data = 0;
            i_read_rdy = 0;
            i_read_size = 0;
            i_tp_blue = 0;
            i_tp_green = 0;
            i_tp_red = 0;
            repeat(5) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State Verification");
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 1'b0, 1'b0, 1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Pixel Read");
            reset_dut();
            i_read_size = 24'd1;
            i_read_rdy = 1'b1;


            wait(o_read_act);
            @(posedge clk);
            #1 i_read_data = 25'h0_ABCDEF;


            wait(o_pixel_rdy);
            @(posedge clk);
            #1 i_pixel_stb = 1'b1;
            @(posedge clk);
            #1 i_pixel_stb = 1'b0;
            i_read_rdy = 1'b0;


            #1;



            check_outputs(8'hEF, 8'hCD, 1'b1, 1'b1, 1'b1, 1'b1, 8'hAB);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multi-Pixel Read (2 Pixels)");
            reset_dut();
            i_read_size = 24'd2;
            i_read_rdy = 1'b1;


            wait(o_read_stb);
            @(posedge clk);
            #1 i_read_data = 25'h0_112233;
            wait(o_pixel_rdy);
            @(posedge clk);
            #1 i_pixel_stb = 1'b1;
            @(posedge clk);
            #1 i_pixel_stb = 1'b0;


            wait(o_read_stb);
            @(posedge clk);
            #1 i_read_data = 25'h0_445566;
            wait(o_pixel_rdy);
            @(posedge clk);
            #1 i_pixel_stb = 1'b1;
            @(posedge clk);
            #1 i_pixel_stb = 1'b0;
            i_read_rdy = 1'b0;


            #1;



            check_outputs(8'h66, 8'h55, 1'b1, 1'b1, 1'b1, 1'b1, 8'h44);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Pattern Check and Data Flow");
            reset_dut();
            i_read_size = 24'd5;
            i_tp_red = 1'b1;
            i_read_rdy = 1'b1;


            wait(o_read_stb);
            @(posedge clk);
            #1 i_read_data = 25'h0_FFFFFF;
            wait(o_pixel_rdy);
            @(posedge clk);
            #1 i_pixel_stb = 1'b1;
            @(posedge clk);
            #1 i_pixel_stb = 1'b0;


            #1;



            check_outputs(8'hFF, 8'hFF, 1'b0, 1'b1, 1'b1, 1'b1, 8'hFF);
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
        input [7:0] expected_o_blue;
        input [7:0] expected_o_green;
        input expected_o_last;
        input expected_o_pixel_rdy;
        input expected_o_read_act;
        input expected_o_read_stb;
        input [7:0] expected_o_red;
        begin
            if (expected_o_blue === (expected_o_blue ^ o_blue ^ expected_o_blue) &&
                expected_o_green === (expected_o_green ^ o_green ^ expected_o_green) &&
                expected_o_last === (expected_o_last ^ o_last ^ expected_o_last) &&
                expected_o_pixel_rdy === (expected_o_pixel_rdy ^ o_pixel_rdy ^ expected_o_pixel_rdy) &&
                expected_o_read_act === (expected_o_read_act ^ o_read_act ^ expected_o_read_act) &&
                expected_o_read_stb === (expected_o_read_stb ^ o_read_stb ^ expected_o_read_stb) &&
                expected_o_red === (expected_o_red ^ o_red ^ expected_o_red)) begin
                $display("PASS");
                $display("  Outputs: o_blue=%h, o_green=%h, o_last=%b, o_pixel_rdy=%b, o_read_act=%b, o_read_stb=%b, o_red=%h",
                         o_blue, o_green, o_last, o_pixel_rdy, o_read_act, o_read_stb, o_red);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_blue=%h, o_green=%h, o_last=%b, o_pixel_rdy=%b, o_read_act=%b, o_read_stb=%b, o_red=%h",
                         expected_o_blue, expected_o_green, expected_o_last, expected_o_pixel_rdy, expected_o_read_act, expected_o_read_stb, expected_o_red);
                $display("  Got:      o_blue=%h, o_green=%h, o_last=%b, o_pixel_rdy=%b, o_read_act=%b, o_read_stb=%b, o_red=%h",
                         o_blue, o_green, o_last, o_pixel_rdy, o_read_act, o_read_stb, o_red);
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
        $dumpvars(0,clk, i_pixel_stb, i_read_data, i_read_rdy, i_read_size, i_tp_blue, i_tp_green, i_tp_red, rst, o_blue, o_green, o_last, o_pixel_rdy, o_read_act, o_read_stb, o_red);
    end

endmodule
