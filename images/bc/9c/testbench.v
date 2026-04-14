`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg carry_in;
    reg clk;
    reg invert;
    reg [2:0] opcode;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .carry_in(carry_in),
        .clk(clk),
        .invert(invert),
        .opcode(opcode),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            carry_in = 0;
            invert = 0;
            opcode = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 4'h3; B = 4'h2; carry_in = 0; invert = 0; opcode = 3'b000;
            @(posedge clk); #1;
            $display("Test %0d: Addition (3 + 2)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 4'h7; B = 4'h1; carry_in = 1; invert = 0; opcode = 3'b000;
            @(posedge clk); #1;
            $display("Test %0d: Addition with Carry (7 + 1 + 1)", test_num);
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 4'hA; B = 4'h4; carry_in = 0; invert = 0; opcode = 3'b001;
            @(posedge clk); #1;
            $display("Test %0d: Subtraction (10 - 4)", test_num);
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 4'hA; B = 4'h4; carry_in = 1; invert = 0; opcode = 3'b001;
            @(posedge clk); #1;
            $display("Test %0d: Subtraction with Carry (10 - 4 - 1)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 4'b1100; B = 4'b1010; carry_in = 0; invert = 0; opcode = 3'b010;
            @(posedge clk); #1;
            $display("Test %0d: Bitwise AND (12 & 10)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 4'b1010; B = 4'b1010; carry_in = 0; invert = 1; opcode = 3'b011;
            @(posedge clk); #1;
            $display("Test %0d: Bitwise OR with Invert (10 | ~10)", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            A = 4'b1111; B = 4'b1010; carry_in = 0; invert = 0; opcode = 3'b100;
            @(posedge clk); #1;
            $display("Test %0d: Bitwise XOR (15 ^ 10)", test_num);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            A = 4'hF; B = 4'h1; carry_in = 0; invert = 0; opcode = 3'b000;
            @(posedge clk); #1;
            $display("Test %0d: Addition Overflow (15 + 1)", test_num);
            #1;

            check_outputs(4'h0);
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
        $dumpvars(0,A, B, carry_in, clk, invert, opcode, result);
    end

endmodule
