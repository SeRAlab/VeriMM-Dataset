`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] enable;
    reg [2047:0] in;
    reg rst;
    reg [7:0] sel;
    wire [7:0] out1;
    wire [7:0] out2;
    wire [7:0] out3;
    wire [7:0] out4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .in(in),
        .rst(rst),
        .sel(sel),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            sel = 0;
            in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            in = 2048'h0;
            in[7:0] = 8'hA1;
            sel = 8'd0;
            enable = 2'b00;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA1, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            in = 2048'h0;
            in[10*8 +: 8] = 8'hB2;
            sel = 8'd10;
            enable = 2'b01;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'hB2, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            in = 2048'h0;
            in[255*8 +: 8] = 8'hC3;
            sel = 8'd255;
            enable = 2'b10;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'h00, 8'hC3, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            in = 2048'h0;
            in[128*8 +: 8] = 8'hD4;
            sel = 8'd128;
            enable = 2'b11;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'hD4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            for (integer i = 0; i < 256; i = i + 1) begin
                in[i*8 +: 8] = i[7:0];
            end


            sel = 8'd5;
            enable = 2'b00;
            @(posedge clk);
            #1;


            sel = 8'd10;
            enable = 2'b01;
            @(posedge clk);
            #1;


            sel = 8'd15;
            enable = 2'b10;
            @(posedge clk);
            #1;


            sel = 8'd20;
            enable = 2'b11;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h05, 8'h0A, 8'h0F, 8'h14);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            in = 2048'h0;
            in[50*8 +: 8] = 8'hEE;
            sel = 8'd50;
            enable = 2'b00;
            @(posedge clk);
            #1;


            in[60*8 +: 8] = 8'hFF;
            sel = 8'd60;
            enable = 2'b01;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'hEE, 8'hFF, 8'h00, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();


            for (integer i = 0; i < 256; i = i + 1) in[i*8 +: 8] = i[7:0];
            sel = 8'd127;
            enable = 2'b00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h7F, 8'h00, 8'h00, 8'h00);
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
        input [7:0] expected_out1;
        input [7:0] expected_out2;
        input [7:0] expected_out3;
        input [7:0] expected_out4;
        begin
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h, out3=%h, out4=%h",
                         out1, out2, out3, out4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h, out3=%h, out4=%h",
                         expected_out1, expected_out2, expected_out3, expected_out4);
                $display("  Got:      out1=%h, out2=%h, out3=%h, out4=%h",
                         out1, out2, out3, out4);
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
        $dumpvars(0,clk, enable, in, rst, sel, out1, out2, out3, out4);
    end

endmodule
