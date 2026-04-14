`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CLK;
    reg MAC;
    reg RST;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .MAC(MAC),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            A = 0;
            B = 0;
            MAC = 0;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Basic Reset");
            test_num = test_num + 1;
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Multiplication (MAC=0)");
            test_num = test_num + 1;
            reset_dut();
            A = 4'd3;
            B = 4'd4;
            MAC = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Accumulation (MAC=1)");
            test_num = test_num + 1;
            reset_dut();

            A = 4'd5;
            B = 4'd2;
            MAC = 0;
            @(posedge CLK);
            #1;

            A = 4'd4;
            B = 4'd3;
            MAC = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd22);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Multiply by Zero");
            test_num = test_num + 1;
            reset_dut();
            A = 4'd15;
            B = 4'd0;
            MAC = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Maximum 4-bit Multiplication");
            test_num = test_num + 1;
            reset_dut();
            A = 4'hF;
            B = 4'hF;
            MAC = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Multiple Accumulations");
            test_num = test_num + 1;
            reset_dut();

            A = 4'd1; B = 4'd1; MAC = 0;
            @(posedge CLK); #1;

            A = 4'd2; B = 4'd2; MAC = 1;
            @(posedge CLK); #1;

            A = 4'd3; B = 4'd3; MAC = 1;
            @(posedge CLK); #1;

            A = 4'd4; B = 4'd4; MAC = 1;
            @(posedge CLK); #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: MAC Toggle (Accumulate then Overwrite)");
            test_num = test_num + 1;
            reset_dut();

            A = 4'd2; B = 4'd5; MAC = 0;
            @(posedge CLK); #1;

            A = 4'd2; B = 4'd5; MAC = 1;
            @(posedge CLK); #1;

            A = 4'd10; B = 4'd10; MAC = 0;
            @(posedge CLK); #1;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Accumulator Overflow Logic");
            test_num = test_num + 1;
            reset_dut();

            A = 4'hF; B = 4'hF; MAC = 0;
            @(posedge CLK); #1;

            A = 4'd5; B = 4'd10; MAC = 1;
            @(posedge CLK); #1;
            #1;

            check_outputs(8'd19);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Reset Priority");
            test_num = test_num + 1;
            reset_dut();
            A = 4'd5; B = 4'd5; MAC = 0;
            @(posedge CLK); #1;

            RST = 1;
            A = 4'd10; B = 4'd10; MAC = 1;
            @(posedge CLK); #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: MAC with zero product");
            test_num = test_num + 1;
            reset_dut();
            A = 4'd10; B = 4'd10; MAC = 0;
            @(posedge CLK); #1;
            A = 4'd10; B = 4'd0; MAC = 1;
            @(posedge CLK); #1;
            #1;

            check_outputs(8'd100);
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,A, B, CLK, MAC, RST, Q);
    end

endmodule
