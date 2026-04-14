`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg [1:0] op;
    reg rst;
    wire done;
    wire [7:0] result;

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
        .done(done),
        .result(result)
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
            op = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (15 + 25)", test_num);
            reset_dut();
            A = 8'd15; B = 8'd25; op = 2'b00;
            wait(done);
            #1;

            check_outputs(1'b1, 8'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (50 - 20)", test_num);
            reset_dut();
            A = 8'd50; B = 8'd20; op = 2'b01;
            wait(done);
            #1;

            check_outputs(1'b1, 8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (12 * 8)", test_num);
            reset_dut();
            A = 8'd12; B = 8'd8; op = 2'b10;
            wait(done);
            #1;

            check_outputs(1'b1, 8'd96);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division (100 / 5)", test_num);
            reset_dut();
            A = 8'd100; B = 8'd5; op = 2'b11;
            wait(done);
            #1;

            check_outputs(1'b1, 8'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow (200 + 100)", test_num);
            reset_dut();
            A = 8'd200; B = 8'd100; op = 2'b00;
            wait(done);
            #1;

            check_outputs(1'b1, 8'd44);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Underflow (10 - 20)", test_num);
            reset_dut();
            A = 8'd10; B = 8'd20; op = 2'b01;
            wait(done);
            #1;

            check_outputs(1'b1, 8'd246);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication Overflow (40 * 10)", test_num);
            reset_dut();
            A = 8'd40; B = 8'd10; op = 2'b10;
            wait(done);
            #1;

            check_outputs(1'b1, 8'd144);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division with Remainder Truncation (255 / 2)", test_num);
            reset_dut();
            A = 8'd255; B = 8'd2; op = 2'b11;
            wait(done);
            #1;

            check_outputs(1'b1, 8'd127);
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
        input expected_done;
        input [7:0] expected_result;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: done=%b, result=%h",
                         done, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, result=%h",
                         expected_done, expected_result);
                $display("  Got:      done=%b, result=%h",
                         done, result);
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
        $dumpvars(0,A, B, clk, op, rst, done, result);
    end

endmodule
