`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] ALU_in;
    reg [3:0] B;
    reg C;
    reg [2:0] OP;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALU_in(ALU_in),
        .B(B),
        .C(C),
        .OP(OP),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Addition (C=0) then OP Add", test_num);
        A = 4'h2; B = 4'h3; C = 1'b0; ALU_in = 4'h4; OP = 3'b000;

        #1;


        check_outputs(4'h9);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Subtraction (C=1) then OP Add", test_num);
        A = 4'hA; B = 4'h4; C = 1'b1; ALU_in = 4'h2; OP = 3'b000;

        #1;


        check_outputs(4'h8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Addition (C=0) then OP Subtract", test_num);
        A = 4'h5; B = 4'h5; C = 1'b0; ALU_in = 4'h3; OP = 3'b001;

        #1;


        check_outputs(4'h7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Bitwise AND", test_num);
        A = 4'hF; B = 4'h0; C = 1'b0; ALU_in = 4'hA; OP = 3'b010;

        #1;


        check_outputs(4'hA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Bitwise OR", test_num);
        A = 4'h8; B = 4'h0; C = 1'b0; ALU_in = 4'h1; OP = 3'b011;

        #1;


        check_outputs(4'h9);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Bitwise XOR", test_num);
        A = 4'hC; B = 4'h0; C = 1'b0; ALU_in = 4'hF; OP = 3'b100;

        #1;


        check_outputs(4'h3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Bit Shift Left", test_num);
        A = 4'h2; B = 4'h0; C = 1'b0; ALU_in = 4'h0; OP = 3'b101;

        #1;


        check_outputs(4'h4);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Bit Shift Right", test_num);
        A = 4'h8; B = 4'h0; C = 1'b0; ALU_in = 4'h0; OP = 3'b110;

        #1;


        check_outputs(4'h4);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Addition Overflow", test_num);
        A = 4'hF; B = 4'h1; C = 1'b0; ALU_in = 4'h1; OP = 3'b000;

        #1;


        check_outputs(4'h1);
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
        input [3:0] expected_out;
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
