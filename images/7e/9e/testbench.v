`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] CTRL;
    reg clk;
    reg rst;
    wire [31:0] C;
    wire F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CTRL(CTRL),
        .clk(clk),
        .rst(rst),
        .C(C),
        .F(F)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 0;
            B = 0;
            CTRL = 0;
            #12;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 32'd100;
            B = 32'd250;
            CTRL = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 32'd10;
            B = 32'd50;
            CTRL = 2'b01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hFFFFFFD8, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 32'd12;
            B = 32'd12;
            CTRL = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd144, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 32'd1000;
            B = 32'd20;
            CTRL = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd50, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 32'h7FFFFFFF;
            B = 32'h00000001;
            CTRL = 2'b00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h80000000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            CTRL = 2'b00;
            @(posedge clk);
            #2;

            if (C == 0) $display("Setup for Reset Test Failed");


            rst = 1;
            #5;
            #1;

            check_outputs(32'h0, 1'b0);
            rst = 0;
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
        input [31:0] expected_C;
        input expected_F;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_F === (expected_F ^ F ^ expected_F)) begin
                $display("PASS");
                $display("  Outputs: C=%h, F=%b",
                         C, F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, F=%b",
                         expected_C, expected_F);
                $display("  Got:      C=%h, F=%b",
                         C, F);
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
        $dumpvars(0,A, B, CTRL, clk, rst, C, F);
    end

endmodule
