`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] operand;
    reg [2:0] shamt;
    reg toRight;
    wire [5:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .operand(operand),
        .shamt(shamt),
        .toRight(toRight),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        toRight = 1'b0;
        operand = 6'b101101;
        shamt = 3'd0;
        #1;

        check_outputs(6'b101101);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        toRight = 1'b0;
        operand = 6'b000111;
        shamt = 3'd1;
        #1;

        check_outputs(6'b001110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        toRight = 1'b0;
        operand = 6'b101010;
        shamt = 3'd3;
        #1;

        check_outputs(6'b010000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        toRight = 1'b0;
        operand = 6'b111111;
        shamt = 3'd5;
        #1;

        check_outputs(6'b100000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        toRight = 1'b0;
        operand = 6'b111111;
        shamt = 3'd6;
        #1;

        check_outputs(6'b000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        toRight = 1'b1;
        operand = 6'b101101;
        shamt = 3'd0;
        #1;

        check_outputs(6'b101101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        toRight = 1'b1;
        operand = 6'b110000;
        shamt = 3'd1;
        #1;

        check_outputs(6'b011000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        toRight = 1'b1;
        operand = 6'b101010;
        shamt = 3'd3;
        #1;

        check_outputs(6'b000101);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        toRight = 1'b1;
        operand = 6'b111111;
        shamt = 3'd5;
        #1;

        check_outputs(6'b000001);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        toRight = 1'b1;
        operand = 6'b111111;
        shamt = 3'd7;
        #1;

        check_outputs(6'b000000);
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
        input [5:0] expected_out;
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
