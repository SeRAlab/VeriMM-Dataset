`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] opcode;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (A + B)", test_num);
            A = 8'd15;
            B = 8'd27;
            opcode = 3'b000;
            #1;

            check_outputs(8'd42);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (A - B)", test_num);
            A = 8'd100;
            B = 8'd40;
            opcode = 3'b001;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication (A * B)", test_num);
            A = 8'd12;
            B = 8'd5;
            opcode = 3'b010;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division (A / B)", test_num);
            A = 8'd80;
            B = 8'd4;
            opcode = 3'b011;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise AND", test_num);
            A = 8'b10101010;
            B = 8'b11110000;
            opcode = 3'b100;
            #1;

            check_outputs(8'b10100000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise OR", test_num);
            A = 8'b10101010;
            B = 8'b01010101;
            opcode = 3'b101;
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise XOR", test_num);
            A = 8'b11110000;
            B = 8'b10101010;
            opcode = 3'b110;
            #1;

            check_outputs(8'b01011010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid Opcode (Default to 0)", test_num);
            A = 8'd255;
            B = 8'd255;
            opcode = 3'b111;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow Check", test_num);
            A = 8'd200;
            B = 8'd100;
            opcode = 3'b000;

            #1;


            check_outputs(8'd44);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Underflow Check", test_num);
            A = 8'd10;
            B = 8'd20;
            opcode = 3'b001;

            #1;


            check_outputs(8'hF6);
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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

endmodule
