`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset_n;
    wire carry;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset_n(reset_n),
        .carry(carry),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            a = 0;
            b = 0;
            @(posedge clk);
            #1 reset_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition (5 + 10)", test_num);
            reset_dut();
            a = 8'd5;
            b = 8'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Carry Out (255 + 1)", test_num);
            reset_dut();
            a = 8'hFF;
            b = 8'h01;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Addition (0 + 0)", test_num);
            reset_dut();
            a = 8'h00;
            b = 8'h00;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Sum without Carry (128 + 127)", test_num);
            reset_dut();
            a = 8'd128;
            b = 8'd127;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry Out with High Sum (200 + 100)", test_num);
            reset_dut();
            a = 8'd200;
            b = 8'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd44);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max values (255 + 255)", test_num);
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'hFE);
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
        input expected_carry;
        input [7:0] expected_sum;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, sum=%h",
                         carry, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, sum=%h",
                         expected_carry, expected_sum);
                $display("  Got:      carry=%b, sum=%h",
                         carry, sum);
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
        $dumpvars(0,a, b, clk, reset_n, carry, sum);
    end

endmodule
