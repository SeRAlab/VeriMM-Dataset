`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg X;
    reg carry_in;
    reg clk;
    wire carry_out;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .X(X),
        .carry_in(carry_in),
        .clk(clk),
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
            A = 8'h0;
            B = 8'h0;
            X = 1'b0;
            carry_in = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 8'd15;
            B = 8'd10;
            X = 1'b0;
            carry_in = 1'b0;
            @(posedge clk);
            #1;
            $display("Test Case %0d: A=%d, B=%d, X=%b, Cin=%b", test_num, A, B, X, carry_in);
            #1;

            check_outputs(1'b0, 8'd25);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 8'd100;
            B = 8'd50;
            X = 1'b0;
            carry_in = 1'b1;
            @(posedge clk);
            #1;
            $display("Test Case %0d: A=%d, B=%d, X=%b, Cin=%b", test_num, A, B, X, carry_in);
            #1;

            check_outputs(1'b0, 8'd151);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 8'hFF;
            B = 8'h01;
            X = 1'b0;
            carry_in = 1'b0;
            @(posedge clk);
            #1;
            $display("Test Case %0d: A=%h, B=%h, X=%b, Cin=%b", test_num, A, B, X, carry_in);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 8'd50;
            B = 8'd20;
            X = 1'b1;
            carry_in = 1'b1;
            @(posedge clk);
            #1;
            $display("Test Case %0d (Sub): A=%d, B=%d, X=%b, Cin=%b", test_num, A, B, X, carry_in);
            #1;

            check_outputs(1'b1, 8'd30);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 8'd10;
            B = 8'd5;
            X = 1'b1;
            carry_in = 1'b0;
            @(posedge clk);
            #1;

            $display("Test Case %0d: A=%d, B=%d, X=%b, Cin=%b", test_num, A, B, X, carry_in);
            #1;

            check_outputs(1'b1, 8'd4);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 8'hFF;
            B = 8'hFF;
            X = 1'b0;
            carry_in = 1'b1;
            @(posedge clk);
            #1;

            $display("Test Case %0d: A=%h, B=%h, X=%b, Cin=%b", test_num, A, B, X, carry_in);
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            A = 8'hAA;
            B = 8'h00;
            X = 1'b1;
            carry_in = 1'b0;
            @(posedge clk);
            #1;

            $display("Test Case %0d: A=%h, B=%h, X=%b, Cin=%b", test_num, A, B, X, carry_in);
            #1;

            check_outputs(1'b1, 8'hA9);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            A = 8'h00;
            B = 8'h00;
            X = 1'b0;
            carry_in = 1'b0;
            @(posedge clk);
            #1;
            $display("Test Case %0d: A=%h, B=%h, X=%b, Cin=%b", test_num, A, B, X, carry_in);
            #1;

            check_outputs(1'b0, 8'h00);
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
        input [7:0] expected_sum;
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
        $dumpvars(0,A, B, X, carry_in, clk, carry_out, sum);
    end

endmodule
