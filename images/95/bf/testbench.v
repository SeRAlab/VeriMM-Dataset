`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg shift;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .shift(shift),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'b0000;
            B = 4'b0000;
            shift = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 4'b1011;
            B = 4'd2;
            shift = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: Pass-through mode (shift=0)", test_num);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 4'b0001;
            B = 4'd1;
            shift = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Shift left by 1 (0001 << 1)", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 4'b0011;
            B = 4'd2;
            shift = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Shift left by 2 (0011 << 2)", test_num);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 4'b0001;
            B = 4'd3;
            shift = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Shift left by 3 (0001 << 3)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 4'b1101;
            B = 4'd0;
            shift = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Shift left by 0 (1101 << 0)", test_num);
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 4'b1111;
            B = 4'd4;
            shift = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Shift left by 4 (1111 << 4)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            A = 4'b0101;
            B = 4'd3;
            shift = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: Pass-through mode with B non-zero (shift=0)", test_num);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            A = 4'b1100;
            B = 4'd1;
            shift = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Shift left by 1 with bit loss (1100 << 1)", test_num);
            #1;

            check_outputs(4'b1000);
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
        input [3:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,A, B, clk, shift, result);
    end

endmodule
