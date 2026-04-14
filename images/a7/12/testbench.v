`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg clk;
    reg [1:0] op;
    reg rst;
    wire [31:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .op(op),
        .rst(rst),
        .C(C)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            A = 0;
            B = 0;
            op = 0;
            @(negedge clk);
            rst = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Addition (15 + 25)");
            reset_dut();
            A = 32'd15;
            B = 32'd25;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd40);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Addition (50 + -20)");
            reset_dut();
            A = 32'd50;
            B = -32'd20;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd30);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Subtraction (100 - 40)");
            reset_dut();
            A = 32'd100;
            B = 32'd40;
            op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd60);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Subtraction (10 - 20)");
            reset_dut();
            A = 32'd10;
            B = 32'd20;
            op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-32'd10);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Multiplication (12 * 8)");
            reset_dut();
            A = 32'd12;
            B = 32'd8;
            op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd96);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiplication (5 * -4)");
            reset_dut();
            A = 32'd5;
            B = -32'd4;
            op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-32'd20);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Division (100 / 5)");
            reset_dut();
            A = 32'd100;
            B = 32'd5;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd20);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Division (-42 / 7)");
            reset_dut();
            A = -32'd42;
            B = 32'd7;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-32'd6);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Boundary Case (32'h7FFFFFFF + 0)");
            reset_dut();
            A = 32'h7FFFFFFF;
            B = 32'h00000000;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h7FFFFFFF);
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
        begin
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
        $dumpvars(0,A, B, clk, op, rst, C);
    end

endmodule
