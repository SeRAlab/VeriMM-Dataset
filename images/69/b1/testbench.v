`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] op_code;
    reg reset;
    wire carry;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .op_code(op_code),
        .reset(reset),
        .carry(carry),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in1 = 0;
            in2 = 0;
            op_code = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase002: Addition (No Carry)");
            reset_dut();
            op_code = 4'd0;
            in1 = 4'h5;
            in2 = 4'h3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 4'h8);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase003: Addition (With Carry)");
            reset_dut();
            op_code = 4'd0;
            in1 = 4'hA;
            in2 = 4'h7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 4'h1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase004: Subtraction");
            reset_dut();
            op_code = 4'd1;
            in1 = 4'hF;
            in2 = 4'h6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 4'h9);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase005: Multiplication (No Carry)");
            reset_dut();
            op_code = 4'd2;
            in1 = 4'h3;
            in2 = 4'h4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 4'hC);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase006: Multiplication (With Carry)");
            reset_dut();
            op_code = 4'd2;
            in1 = 4'h5;
            in2 = 4'h4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 4'h4);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase007: Bitwise AND");
            reset_dut();
            op_code = 4'd3;
            in1 = 4'b1010;
            in2 = 4'b1100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 4'b1000);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase008: Bitwise OR");
            reset_dut();
            op_code = 4'd4;
            in1 = 4'b1010;
            in2 = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 4'b1111);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase009: Bitwise XOR");
            reset_dut();
            op_code = 4'd5;
            in1 = 4'b1010;
            in2 = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 4'b0101);
        end
        endtask

    task testcase010;

        begin
            $display("Running Testcase010: Boundary Addition");
            reset_dut();
            op_code = 4'd0;
            in1 = 4'hF;
            in2 = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 4'hE);
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
        input expected_carry;
        input [3:0] expected_out;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, out=%h",
                         carry, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, out=%h",
                         expected_carry, expected_out);
                $display("  Got:      carry=%b, out=%h",
                         carry, out);
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
        $dumpvars(0,clk, in1, in2, op_code, reset, carry, out);
    end

endmodule
