`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg SUB;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .SUB(SUB),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Simple Addition (SUB=0, A=3, B=5)", test_num);
        A = 4'd3;
        B = 4'd5;
        SUB = 1'b0;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition with Overflow (SUB=0, A=15, B=1)", test_num);
        A = 4'd15;
        B = 4'd1;
        SUB = 1'b0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Simple Subtraction (SUB=1, A=10, B=4)", test_num);
        A = 4'd10;
        B = 4'd4;
        SUB = 1'b1;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction Negative Result (SUB=1, A=4, B=10)", test_num);
        A = 4'd4;
        B = 4'd10;
        SUB = 1'b1;
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Zero Case (SUB=1, A=8, B=8)", test_num);
        A = 4'd8;
        B = 4'd8;
        SUB = 1'b1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Underflow Case (SUB=1, A=0, B=1)", test_num);
        A = 4'd0;
        B = 4'd1;
        SUB = 1'b1;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Max values Addition (SUB=0, A=7, B=8)", test_num);
        A = 4'd7;
        B = 4'd8;
        SUB = 1'b0;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Toggle SUB (SUB=0 then 1, A=5, B=2)", test_num);
        A = 4'd5;
        B = 4'd2;
        SUB = 1'b0;
        #1;
        SUB = 1'b1;
        #1;

        check_outputs(4'd3);
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
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
