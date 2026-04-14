`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg clk;
    reg [7:0] d;
    reg [7:0] in1;
    reg [7:0] in2;
    reg reset;
    wire [7:0] final_out;
    wire [15:0] out;
    wire [7:0] out_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .in1(in1),
        .in2(in2),
        .reset(reset),
        .final_out(final_out),
        .out(out),
        .out_lo(out_lo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in1 = 0;
            in2 = 0;
            a = 8'hFF;
            b = 8'hFF;
            c = 8'hFF;
            d = 8'hFF;
            @(posedge clk);
            #1;
            reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            in1 = 8'd10;
            in2 = 8'd5;
            a = 8'd5;
            b = 8'd10;
            c = 8'd15;
            d = 8'd20;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Simple multiplication (10*5) and min(5,10,15,20)", test_num);
            #1;

            check_outputs(8'd5, 16'd50, 8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            in1 = 8'd16;
            in2 = 8'd16;
            a = 8'd100;
            b = 8'd80;
            c = 8'd60;
            d = 8'd40;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Multi-byte result (16*16=256) and min(100,80,60,40)", test_num);

            #1;


            check_outputs(8'd40, 16'd256, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            in1 = 8'd0;
            in2 = 8'd255;
            a = 8'd50;
            b = 8'd12;
            c = 8'd50;
            d = 8'd50;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Zero multiplication (0*255) and min(50,12,50,50)", test_num);
            #1;

            check_outputs(8'd12, 16'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            in1 = 8'd255;
            in2 = 8'd255;
            a = 8'd200;
            b = 8'd200;
            c = 8'd150;
            d = 8'd200;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Max multiplication (255*255) and min(200,200,150,200)", test_num);

            #1;


            check_outputs(8'd150, 16'd65025, 8'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            in1 = 8'd12;
            in2 = 8'd11;
            a = 8'd255;
            b = 8'd255;
            c = 8'd255;
            d = 8'd255;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Identical min inputs (255,255,255,255)", test_num);
            #1;

            check_outputs(8'd255, 16'd132, 8'd132);
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
        input [7:0] expected_final_out;
        input [15:0] expected_out;
        input [7:0] expected_out_lo;
        begin
            if (expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo)) begin
                $display("PASS");
                $display("  Outputs: final_out=%h, out=%h, out_lo=%h",
                         final_out, out, out_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_out=%h, out=%h, out_lo=%h",
                         expected_final_out, expected_out, expected_out_lo);
                $display("  Got:      final_out=%h, out=%h, out_lo=%h",
                         final_out, out, out_lo);
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
        $dumpvars(0,a, b, c, clk, d, in1, in2, reset, final_out, out, out_lo);
    end

endmodule
