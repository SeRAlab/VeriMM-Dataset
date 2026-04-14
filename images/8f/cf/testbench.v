`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] op;
    reg start;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .start(start),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        start = 0;
        forever #5 start = ~start;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            op = 0;

            @(negedge start);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Addition (15 + 27)", test_num);
            a = 8'd15;
            b = 8'd27;
            op = 2'd0;
            @(posedge start);
            #2;
            #1;

            check_outputs(16'd42);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Subtraction (100 - 35)", test_num);
            a = 8'd100;
            b = 8'd35;
            op = 2'd1;
            @(posedge start);
            #2;
            #1;

            check_outputs(16'd65);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Multiplication (12 * 12)", test_num);
            a = 8'd12;
            b = 8'd12;
            op = 2'd2;
            @(posedge start);
            #2;
            #1;

            check_outputs(16'd144);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Division (200 / 5)", test_num);
            a = 8'd200;
            b = 8'd5;
            op = 2'd3;
            @(posedge start);
            #2;
            #1;

            check_outputs(16'd40);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Addition Overflow (200 + 100)", test_num);
            a = 8'd200;
            b = 8'd100;
            op = 2'd0;
            @(posedge start);
            #2;
            #1;

            check_outputs(16'd300);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Subtraction Wrap-around (10 - 20)", test_num);
            a = 8'd10;
            b = 8'd20;
            op = 2'd1;
            @(posedge start);
            #2;

            #1;


            check_outputs(16'hFFF6);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Multiplication Max (255 * 255)", test_num);
            a = 8'd255;
            b = 8'd255;
            op = 2'd2;
            @(posedge start);
            #2;
            #1;

            check_outputs(16'd65025);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Division Truncation (7 / 2)", test_num);
            a = 8'd7;
            b = 8'd2;
            op = 2'd3;
            @(posedge start);
            #2;
            #1;

            check_outputs(16'd3);
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
        input [15:0] expected_result;
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
        $dumpvars(0,a, b, op, start, result);
    end

endmodule
