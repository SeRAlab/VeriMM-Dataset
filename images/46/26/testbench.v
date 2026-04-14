`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [1:0] op;
    reg rst_n;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .op(op),
        .rst_n(rst_n),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            op = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Addition (0 + 15)", test_num);
            reset_dut();
            data_in = 8'd15;
            op = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Subtraction (15 - 5)", test_num);

            reset_dut();

            data_in = 8'd15; op = 2'b00; @(posedge clk);

            data_in = 8'd5;
            op = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiplication (10 * 4)", test_num);
            reset_dut();

            data_in = 8'd10; op = 2'b00; @(posedge clk);

            data_in = 8'd4;
            op = 2'b10;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Division (40 / 8)", test_num);
            reset_dut();

            data_in = 8'd40; op = 2'b00; @(posedge clk);

            data_in = 8'd8;
            op = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Division by Zero (Expect 0)", test_num);
            reset_dut();

            data_in = 8'd100; op = 2'b00; @(posedge clk);

            data_in = 8'd0;
            op = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Addition Overflow (200 + 100 = 300 -> 44)", test_num);
            reset_dut();
            data_in = 8'd200; op = 2'b00; @(posedge clk);
            data_in = 8'd100; op = 2'b00; @(posedge clk);
            #1 #1;
 check_outputs(8'd44);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Subtraction Underflow (5 - 10 = -5 -> 251)", test_num);
            reset_dut();
            data_in = 8'd5; op = 2'b00; @(posedge clk);
            data_in = 8'd10; op = 2'b01; @(posedge clk);
            #1 #1;
 check_outputs(8'd251);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Chained Operations ((0+10)*5)/2", test_num);
            reset_dut();
            data_in = 8'd10; op = 2'b00; @(posedge clk);
            data_in = 8'd5;  op = 2'b10; @(posedge clk);
            data_in = 8'd2;  op = 2'b11; @(posedge clk);
            #1 #1;
 check_outputs(8'd25);
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
        input [7:0] expected_result;
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
        $dumpvars(0,clk, data_in, op, rst_n, result);
    end

endmodule
