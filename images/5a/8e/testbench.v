`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg [4:0] fn;
    reg rst;
    wire Cout;
    wire [7:0] Y;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .fn(fn),
        .rst(rst),
        .Cout(Cout),
        .Y(Y),
        .Zero(Zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            A = 0;
            B = 0;
            fn = 0;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Addition (10 + 20)");
            reset_dut();
            A = 8'sd10;
            B = 8'sd20;
            fn = 5'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'sd30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Addition with Carry (200 + 100 - unsigned view)");
            reset_dut();
            A = 8'hC8;
            B = 8'h64;
            fn = 5'd0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 8'h2C, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Subtraction (15 - 15)");
            reset_dut();
            A = 8'sd15;
            B = 8'sd15;
            fn = 5'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'sd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Bitwise AND (0xAA & 0xF0)");
            reset_dut();
            A = 8'hAA;
            B = 8'hF0;
            fn = 5'd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'hA0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bitwise OR (0x55 | 0x0F)");
            reset_dut();
            A = 8'h55;
            B = 8'h0F;
            fn = 5'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'h5F, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Bitwise XOR (0xFF ^ 0xAA)");
            reset_dut();
            A = 8'hFF;
            B = 8'hAA;
            fn = 5'd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'h55, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Bitwise NOR (0x00 ~| 0x00)");
            reset_dut();
            A = 8'h00;
            B = 8'h00;
            fn = 5'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'hFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: SLL (0x01 << 3)");
            reset_dut();
            A = 8'h01;
            B = 8'd3;
            fn = 5'd6;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'h08, 1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: SRL (0x80 >> 1)");
            reset_dut();
            A = 8'h80;
            B = 8'd1;
            fn = 5'd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'h40, 1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: SRA (0xFE >>> 1)");
            reset_dut();
            A = 8'hFE;
            B = 8'd1;
            fn = 5'd8;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'hFF, 1'b0);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Addition (-10 + -10)");
            reset_dut();
            A = -8'sd10;
            B = -8'sd10;
            fn = 5'd0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, -8'sd20, 1'b0);
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
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input expected_Cout;
        input [7:0] expected_Y;
        input expected_Zero;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Y=%h, Zero=%b",
                         Cout, Y, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Y=%h, Zero=%b",
                         expected_Cout, expected_Y, expected_Zero);
                $display("  Got:      Cout=%b, Y=%h, Zero=%b",
                         Cout, Y, Zero);
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
        $dumpvars(0,A, B, clk, fn, rst, Cout, Y, Zero);
    end

endmodule
