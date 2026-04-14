`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg sub;
    wire carry_out;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .sub(sub),
        .carry_out(carry_out),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'b0;
            B = 4'b0;
            sub = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Addition 5 + 3", test_num);
            A = 4'd5;
            B = 4'd3;
            sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Addition 15 + 1 (Overflow)", test_num);
            A = 4'hF;
            B = 4'h1;
            sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction 10 - 4", test_num);
            A = 4'd10;
            B = 4'd4;
            sub = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'h6);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction 3 - 7 (Negative result)", test_num);
            A = 4'd3;
            B = 4'd7;
            sub = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'hC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Addition 15 + 15", test_num);
            A = 4'hF;
            B = 4'hF;
            sub = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'hE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction 8 - 0", test_num);
            A = 4'h8;
            B = 4'h0;
            sub = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'h8);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction 12 - 12", test_num);
            A = 4'd12;
            B = 4'd12;
            sub = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Addition 0 + 0", test_num);
            A = 4'h0;
            B = 4'h0;
            sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h0);
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
        input expected_carry_out;
        input [3:0] expected_sum;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, sum=%h",
                         carry_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, sum=%h",
                         expected_carry_out, expected_sum);
                $display("  Got:      carry_out=%b, sum=%h",
                         carry_out, sum);
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
        $dumpvars(0,A, B, clk, sub, carry_out, sum);
    end

endmodule
