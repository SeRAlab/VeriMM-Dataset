`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] code;
    reg [1:0] op;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .code(code),
        .op(op),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: ALU Op 00 (Load/Store - Expect Add)", test_num);
        op = 2'b00;
        code = 6'b000000;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: ALU Op 01 (Branch - Expect Subtract)", test_num);
        op = 2'b01;
        code = 6'b000000;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: ALU Op 10, Code 100000 (R-type Add)", test_num);
        op = 2'b10;
        code = 6'b100000;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: ALU Op 10, Code 100010 (R-type Subtract)", test_num);
        op = 2'b10;
        code = 6'b100010;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: ALU Op 10, Code 100100 (R-type And)", test_num);
        op = 2'b10;
        code = 6'b100100;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: ALU Op 10, Code 100101 (R-type Or)", test_num);
        op = 2'b10;
        code = 6'b100101;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: ALU Op 10, Code 101010 (R-type Set Less Than)", test_num);
        op = 2'b10;
        code = 6'b101010;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: ALU Op 00 with non-zero Code (Should still be Add)", test_num);
        op = 2'b00;
        code = 6'b111111;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: ALU Op 01 with non-zero Code (Should still be Subtract)", test_num);
        op = 2'b01;
        code = 6'b101010;
        #1;

        check_outputs(4'b0110);
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
