`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg [7:0] in_Cb;
    reg [7:0] in_Cr;
    reg [7:0] in_Y;
    reg in_de;
    reg in_hsync;
    reg in_vsync;
    reg rst;
    wire [7:0] out_Cb;
    wire [7:0] out_Cr;
    wire [7:0] out_Y;
    wire out_de;
    wire out_hsync;
    wire out_vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .in_Cb(in_Cb),
        .in_Cr(in_Cr),
        .in_Y(in_Y),
        .in_de(in_de),
        .in_hsync(in_hsync),
        .in_vsync(in_vsync),
        .rst(rst),
        .out_Cb(out_Cb),
        .out_Cr(out_Cr),
        .out_Y(out_Y),
        .out_de(out_de),
        .out_hsync(out_hsync),
        .out_vsync(out_vsync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ce = 0;
            in_Y = 0;
            in_Cb = 0;
            in_Cr = 0;
            in_de = 0;
            in_hsync = 0;
            in_vsync = 0;
            repeat(10) @(posedge clk);
            #1;
            rst = 0;
            repeat(5) @(posedge clk);
            ce = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i, j;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Constant inputs (90)", test_num);
            reset_dut();
            in_vsync = 1;
            fork
                begin

                    for (i = 0; i < 5; i = i + 1) begin
                        in_hsync = 1;
                        for (j = 0; j < 15; j = j + 1) begin
                            in_de = 1; in_Y = 90; in_Cb = 90; in_Cr = 90;
                            @(posedge clk);
                        end
                        in_de = 0; in_hsync = 0;
                        repeat(10) @(posedge clk);
                    end
                end
                begin
                    wait(out_de == 1);
                    @(negedge clk);
                    #1;

                    check_outputs(8'd90, 8'd90, 8'd90, 1'b1, 1'b1, 1'b1);
                end
            join_any
            disable fork;
            repeat(5) @(posedge clk);
        end
        endtask

    task testcase002;

        integer i, j;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zero inputs", test_num);
            reset_dut();
            in_vsync = 1;
            fork
                begin
                    for (i = 0; i < 5; i = i + 1) begin
                        in_hsync = 1;
                        for (j = 0; j < 15; j = j + 1) begin
                            in_de = 1; in_Y = 0; in_Cb = 0; in_Cr = 0;
                            @(posedge clk);
                        end
                        in_de = 0; in_hsync = 0;
                        repeat(10) @(posedge clk);
                    end
                end
                begin
                    wait(out_de == 1);
                    @(negedge clk);
                    #1;

                    check_outputs(8'd0, 8'd0, 8'd0, 1'b1, 1'b1, 1'b1);
                end
            join_any
            disable fork;
            repeat(5) @(posedge clk);
        end
        endtask

    task testcase003;

        integer i, j;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arithmetic Mean (Sum=450, Mean=50)", test_num);
            reset_dut();
            in_vsync = 1;
            fork
                begin
                    for (i = 0; i < 5; i = i + 1) begin
                        in_hsync = 1;
                        for (j = 0; j < 15; j = j + 1) begin
                            in_de = 1;
                            if (i == 0 && j < 3) in_Y = (j+1)*10;
                            else if (i == 1 && j < 3) in_Y = (j+4)*10;
                            else if (i == 2 && j < 3) in_Y = (j+7)*10;
                            else in_Y = 0;
                            in_Cb = in_Y; in_Cr = in_Y;
                            @(posedge clk);
                        end
                        in_de = 0; in_hsync = 0;
                        repeat(10) @(posedge clk);
                    end
                end
                begin
                    wait(out_de == 1);
                    @(negedge clk);
                    #1;

                    check_outputs(8'd50, 8'd50, 8'd50, 1'b1, 1'b1, 1'b1);
                end
            join_any
            disable fork;
            repeat(5) @(posedge clk);
        end
        endtask

    task testcase004;

        integer i, j;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum intensity (255)", test_num);
            reset_dut();
            in_vsync = 1;
            fork
                begin
                    for (i = 0; i < 5; i = i + 1) begin
                        in_hsync = 1;
                        for (j = 0; j < 15; j = j + 1) begin
                            in_de = 1; in_Y = 255; in_Cb = 255; in_Cr = 255;
                            @(posedge clk);
                        end
                        in_de = 0; in_hsync = 0;
                        repeat(10) @(posedge clk);
                    end
                end
                begin
                    wait(out_de == 1);
                    @(negedge clk);
                    #1;

                    check_outputs(8'd255, 8'd255, 8'd255, 1'b1, 1'b1, 1'b1);
                end
            join_any
            disable fork;
            repeat(5) @(posedge clk);
        end
        endtask

    task testcase005;

        integer i, j;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Impulse response (Sum=81, Mean=9)", test_num);
            reset_dut();
            in_vsync = 1;
            fork
                begin
                    for (i = 0; i < 5; i = i + 1) begin
                        in_hsync = 1;
                        for (j = 0; j < 15; j = j + 1) begin
                            in_de = 1;
                            if (i == 1 && j == 1) begin
                                in_Y = 81; in_Cb = 81; in_Cr = 81;
                            end else begin
                                in_Y = 0; in_Cb = 0; in_Cr = 0;
                            end
                            @(posedge clk);
                        end
                        in_de = 0; in_hsync = 0;
                        repeat(10) @(posedge clk);
                    end
                end
                begin
                    wait(out_de == 1);
                    @(negedge clk);
                    #1;

                    check_outputs(8'd9, 8'd9, 8'd9, 1'b1, 1'b1, 1'b1);
                end
            join_any
            disable fork;
            repeat(5) @(posedge clk);
        end
        endtask

    task testcase006;

        integer i, j;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Integer division check (Sum=10, Mean=1)", test_num);
            reset_dut();
            in_vsync = 1;
            fork
                begin
                    for (i = 0; i < 5; i = i + 1) begin
                        in_hsync = 1;
                        for (j = 0; j < 15; j = j + 1) begin
                            in_de = 1;
                            if (i == 1 && (j == 0 || j == 1)) begin
                                in_Y = 5; in_Cb = 5; in_Cr = 5;
                            end else begin
                                in_Y = 0; in_Cb = 0; in_Cr = 0;
                            end
                            @(posedge clk);
                        end
                        in_de = 0; in_hsync = 0;
                        repeat(10) @(posedge clk);
                    end
                end
                begin
                    wait(out_de == 1);
                    @(negedge clk);
                    #1;

                    check_outputs(8'd1, 8'd1, 8'd1, 1'b1, 1'b1, 1'b1);
                end
            join_any
            disable fork;
            repeat(5) @(posedge clk);
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
        input [7:0] expected_out_Cb;
        input [7:0] expected_out_Cr;
        input [7:0] expected_out_Y;
        input expected_out_de;
        input expected_out_hsync;
        input expected_out_vsync;
        begin
            if (expected_out_Cb === (expected_out_Cb ^ out_Cb ^ expected_out_Cb) &&
                expected_out_Cr === (expected_out_Cr ^ out_Cr ^ expected_out_Cr) &&
                expected_out_Y === (expected_out_Y ^ out_Y ^ expected_out_Y) &&
                expected_out_de === (expected_out_de ^ out_de ^ expected_out_de) &&
                expected_out_hsync === (expected_out_hsync ^ out_hsync ^ expected_out_hsync) &&
                expected_out_vsync === (expected_out_vsync ^ out_vsync ^ expected_out_vsync)) begin
                $display("PASS");
                $display("  Outputs: out_Cb=%h, out_Cr=%h, out_Y=%h, out_de=%b, out_hsync=%b, out_vsync=%b",
                         out_Cb, out_Cr, out_Y, out_de, out_hsync, out_vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_Cb=%h, out_Cr=%h, out_Y=%h, out_de=%b, out_hsync=%b, out_vsync=%b",
                         expected_out_Cb, expected_out_Cr, expected_out_Y, expected_out_de, expected_out_hsync, expected_out_vsync);
                $display("  Got:      out_Cb=%h, out_Cr=%h, out_Y=%h, out_de=%b, out_hsync=%b, out_vsync=%b",
                         out_Cb, out_Cr, out_Y, out_de, out_hsync, out_vsync);
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
        $dumpvars(0,ce, clk, in_Cb, in_Cr, in_Y, in_de, in_hsync, in_vsync, rst, out_Cb, out_Cr, out_Y, out_de, out_hsync, out_vsync);
    end

endmodule
