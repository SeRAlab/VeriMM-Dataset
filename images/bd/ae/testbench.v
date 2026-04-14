`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] op;
    reg reset;
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
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin


            @(posedge reset);
            #5;
            @(negedge reset);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 8'd15; b = 8'd25; op = 2'b00;
            #5;
            $display("Testcase %0d: Addition (15 + 25)", test_num);
            #1;

            check_outputs(16'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 8'hFF; b = 8'hFF; op = 2'b00;
            #5;
            $display("Testcase %0d: Addition Max (255 + 255)", test_num);
            #1;

            check_outputs(16'd510);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 8'd100; b = 8'd40; op = 2'b01;
            #5;
            $display("Testcase %0d: Subtraction (100 - 40)", test_num);
            #1;

            check_outputs(16'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 8'd10; b = 8'd20; op = 2'b01;
            #5;
            $display("Testcase %0d: Subtraction Negative (10 - 20)", test_num);

            #1;


            check_outputs(16'hFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 8'd12; b = 8'd12; op = 2'b10;
            #5;
            $display("Testcase %0d: Multiplication (12 * 12)", test_num);
            #1;

            check_outputs(16'd144);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 8'hFF; b = 8'hFF; op = 2'b10;
            #5;
            $display("Testcase %0d: Multiplication Max (255 * 255)", test_num);
            #1;

            check_outputs(16'd65025);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            a = 8'd100; b = 8'd10; op = 2'b11;
            #5;
            $display("Testcase %0d: Division (100 / 10)", test_num);
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            a = 8'd10; b = 8'd3; op = 2'b11;
            #5;
            $display("Testcase %0d: Division Truncation (10 / 3)", test_num);
            #1;

            check_outputs(16'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            a = 8'd50; b = 8'd0; op = 2'b11;
            #5;
            $display("Testcase %0d: Division by Zero", test_num);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;

            @(posedge reset);
            a = 8'd25; b = 8'd25; op = 2'b00;
            #2;
            $display("Testcase %0d: Reset State Verification", test_num);
            #1;

            check_outputs(16'd0);
            @(negedge reset);
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
        $dumpvars(0,a, b, op, reset, result);
    end

endmodule
