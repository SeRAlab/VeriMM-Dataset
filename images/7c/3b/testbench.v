`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg reset;
    reg [1:0] sel;
    wire [15:0] out;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .sel(sel),
        .out(out),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0;
            b = 0;
            sel = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 4'd2; b = 4'd3; sel = 2'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001, 8'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 4'd4; b = 4'd5; sel = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002, 8'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 4'd15; b = 4'd15; sel = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0004, 8'd225);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 4'd15; b = 4'd1; sel = 2'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0008, 8'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 4'd0; b = 4'd12; sel = 2'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 4'd13; b = 4'd0; sel = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            a = 4'd7; b = 4'd9; sel = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0004, 8'd63);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            a = 4'd10; b = 4'd8; sel = 2'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0008, 8'd80);
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
        input [15:0] expected_out;
        input [7:0] expected_product;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: out=%h, product=%h",
                         out, product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, product=%h",
                         expected_out, expected_product);
                $display("  Got:      out=%h, product=%h",
                         out, product);
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
        $dumpvars(0,a, b, clk, reset, sel, out, product);
    end

endmodule
