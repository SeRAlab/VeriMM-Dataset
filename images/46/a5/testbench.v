`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] A;
    reg [2:0] B;
    reg Cin;
    reg clk;
    wire Cout;
    wire [2:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .clk(clk),
        .Cout(Cout),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 3'b000;
            B = 3'b000;
            Cin = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 3'b000;
            B = 3'b000;
            Cin = 1'b0;
            @(posedge clk);
            #1;
            $display("Test Case 001: 0 + 0 + 0");
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 3'd1;
            B = 3'd2;
            Cin = 1'b0;
            @(posedge clk);
            #1;
            $display("Test Case 002: 1 + 2 + 0");
            #1;

            check_outputs(1'b0, 3'd3);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 3'd1;
            B = 3'd1;
            Cin = 1'b1;
            @(posedge clk);
            #1;
            $display("Test Case 003: 1 + 1 + 1");
            #1;

            check_outputs(1'b0, 3'd3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 3'b011;
            B = 3'b001;
            Cin = 1'b0;
            @(posedge clk);
            #1;
            $display("Test Case 004: 3 + 1 + 0 (Internal carry)");
            #1;

            check_outputs(1'b0, 3'b100);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 3'd4;
            B = 3'd4;
            Cin = 1'b0;
            @(posedge clk);
            #1;
            $display("Test Case 005: 4 + 4 + 0 (Carry out)");
            #1;

            check_outputs(1'b1, 3'b000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 3'b111;
            B = 3'b111;
            Cin = 1'b1;
            @(posedge clk);
            #1;
            $display("Test Case 006: Max values (7 + 7 + 1)");
            #1;

            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 3'd7;
            B = 3'd1;
            Cin = 1'b0;
            @(posedge clk);
            #1;
            $display("Test Case 007: 7 + 1 + 0");
            #1;

            check_outputs(1'b1, 3'b000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            A = 3'd3;
            B = 3'd4;
            Cin = 1'b0;
            @(posedge clk);
            #1;
            $display("Test Case 008: 3 + 4 + 0");
            #1;

            check_outputs(1'b0, 3'd7);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            A = 3'b101;
            B = 3'b010;
            Cin = 1'b1;
            @(posedge clk);
            #1;
            $display("Test Case 009: 5 + 2 + 1");
            #1;

            check_outputs(1'b1, 3'b000);
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
        input [2:0] expected_S;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, S=%h",
                         Cout, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, S=%h",
                         expected_Cout, expected_S);
                $display("  Got:      Cout=%b, S=%h",
                         Cout, S);
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
        $dumpvars(0,A, B, Cin, clk, Cout, S);
    end

endmodule
