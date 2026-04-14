`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] op;
    reg reset;
    wire overflow;
    wire [7:0] result;

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
        .overflow(overflow),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

    begin

        wait(reset == 1);
        #1;

        wait(reset == 0);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Reset Behavior Check", test_num);

        a = 8'hFF; b = 8'hFF; op = 2'b10;
        wait(reset == 1);
        #2;

        #1;


        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Addition (10 + 20 = 30)", test_num);
        reset_dut();
        a = 8'd10; b = 8'd20; op = 2'b00;
        #2;
        #1;

        check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Addition Overflow (200 + 100 = 300 -> 44)", test_num);
        reset_dut();
        a = 8'd200; b = 8'd100; op = 2'b00;
        #2;
        #1;

        check_outputs(1'b1, 8'd44);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Subtraction (100 - 30 = 70)", test_num);
        reset_dut();
        a = 8'd100; b = 8'd30; op = 2'b01;
        #2;
        #1;

        check_outputs(1'b0, 8'd70);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Subtraction Underflow (30 - 100 = 186)", test_num);
        reset_dut();
        a = 8'd30; b = 8'd100; op = 2'b01;
        #2;
        #1;

        check_outputs(1'b1, 8'd186);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Multiplication (12 * 10 = 120)", test_num);
        reset_dut();
        a = 8'd12; b = 8'd10; op = 2'b10;
        #2;
        #1;

        check_outputs(1'b0, 8'd120);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Multiplication Overflow (40 * 10 = 400 -> 144)", test_num);
        reset_dut();
        a = 8'd40; b = 8'd10; op = 2'b10;
        #2;
        #1;

        check_outputs(1'b1, 8'd144);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Division (100 / 4 = 25)", test_num);
        reset_dut();
        a = 8'd100; b = 8'd4; op = 2'b11;
        #2;
        #1;

        check_outputs(1'b0, 8'd25);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Division by Zero Detection", test_num);
        reset_dut();
        a = 8'd100; b = 8'd0; op = 2'b11;
        #2;
        #1;

        check_outputs(1'b1, 8'h00);
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
        input expected_overflow;
        input [7:0] expected_result;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
        $dumpvars(0,a, b, op, reset, overflow, result);
    end

endmodule
