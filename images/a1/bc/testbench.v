`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [4:0] multiplicand;
    reg [3:0] multiplier;
    wire [3:0] A_left;
    wire [4:0] q_right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .A_left(A_left),
        .q_right(q_right)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b0100;
        multiplier = 4'b0011;
        multiplicand = 5'b10100;



        #1;




        check_outputs(4'b0010, 5'b01010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'b1000;
        multiplier = 4'b0011;
        multiplicand = 5'b01111;



        #1;




        check_outputs(4'b1100, 5'b00111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'b0001;
        multiplier = 4'b0100;
        multiplicand = 5'b11101;



        #1;




        check_outputs(4'b0010, 5'b11110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'b0010;
        multiplier = 4'b0101;
        multiplicand = 5'b00110;



        #1;




        check_outputs(4'b1110, 5'b10011);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'b1111;
        multiplier = 4'b1110;
        multiplicand = 5'b00001;



        #1;




        check_outputs(4'b1110, 5'b10000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b0000;
        multiplier = 4'b1001;
        multiplicand = 5'b11110;



        #1;




        check_outputs(4'b0011, 5'b11111);
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
        input [3:0] expected_A_left;
        input [4:0] expected_q_right;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_left === (expected_A_left ^ A_left ^ expected_A_left) &&
                expected_q_right === (expected_q_right ^ q_right ^ expected_q_right)) begin
                $display("PASS");
                $display("  Outputs: A_left=%h, q_right=%h",
                         A_left, q_right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_left=%h, q_right=%h",
                         expected_A_left, expected_q_right);
                $display("  Got:      A_left=%h, q_right=%h",
                         A_left, q_right);
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
