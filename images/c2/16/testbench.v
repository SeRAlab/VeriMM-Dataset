`timescale 1ns/1ps

module calculator_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg clk;
    reg enable;
    reg [1:0] op;
    reg reset;
    wire [31:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    calculator dut (
        .A(A),
        .B(B),
        .clk(clk),
        .enable(enable),
        .op(op),
        .reset(reset),
        .C(C)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        A = 0;
        B = 0;
        op = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test Case 001: Addition (5 + 10)");
        A = 32'd5;
        B = 32'd10;
        op = 2'b00;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd15);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test Case 002: Subtraction (50 - 20)");
        A = 32'd50;
        B = 32'd20;
        op = 2'b01;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd30);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test Case 003: Subtraction resulting in negative (10 - 15)");
        A = 32'd10;
        B = 32'd15;
        op = 2'b01;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test Case 004: Multiplication (12 * 8)");
        A = 32'd12;
        B = 32'd8;
        op = 2'b10;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd96);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test Case 005: Division (100 / 4)");
        A = 32'd100;
        B = 32'd4;
        op = 2'b11;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd25);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test Case 006: Multiplication by zero");
        A = 32'hA5A5A5A5;
        B = 32'd0;
        op = 2'b10;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Test Case 007: Enable signal check (Enable=0)");
        A = 32'd10;
        B = 32'd10;
        op = 2'b00;
        enable = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Test Case 008: Large Addition (32-bit wrap)");
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        op = 2'b00;
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        $display("Test Case 009: Consecutive operations (Sub then Div)");

        A = 32'd100; B = 32'd50; op = 2'b01; enable = 1;
        @(posedge clk);
        #1;

        A = 32'd40; B = 32'd5; op = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd8);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = 10;
        $display("Test Case 010: Synchronous Reset during operation");
        A = 32'h12345678;
        B = 32'h00000002;
        op = 2'b10;
        enable = 1;
        @(posedge clk);
        #1;
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("calculator Testbench");
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
        $dumpvars(0,A, B, clk, enable, op, reset, C);
    end

endmodule
