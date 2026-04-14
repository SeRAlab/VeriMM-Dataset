`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg SUB;
    wire OVF;
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
        .OVF(OVF),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition - Positive (3 + 2)", test_num);
        A = 4'd3;
        B = 4'd2;
        SUB = 1'b0;
        #1;

        check_outputs(1'b0, 4'b0101);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition - Positive Overflow (5 + 4)", test_num);
        A = 4'b0101;
        B = 4'b0100;
        SUB = 1'b0;
        #1;

        check_outputs(1'b1, 4'b1001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition - Negative (-3 + -2)", test_num);
        A = 4'b1101;
        B = 4'b1110;
        SUB = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1011);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition - Negative Overflow (-5 + -4)", test_num);
        A = 4'b1011;
        B = 4'b1100;
        SUB = 1'b0;
        #1;

        check_outputs(1'b1, 4'b0111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction - Positive (5 - 2)", test_num);
        A = 4'b0101;
        B = 4'b0010;
        SUB = 1'b1;
        #1;

        check_outputs(1'b0, 4'b0011);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction - Neg B (3 - -2)", test_num);
        A = 4'b0011;
        B = 4'b1110;
        SUB = 1'b1;
        #1;

        check_outputs(1'b0, 4'b0101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction - Pos minus Neg Overflow (5 - -4)", test_num);
        A = 4'b0101;
        B = 4'b1100;
        SUB = 1'b1;
        #1;

        check_outputs(1'b1, 4'b1001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction - Neg minus Pos Overflow (-5 - 4)", test_num);
        A = 4'b1011;
        B = 4'b0100;
        SUB = 1'b1;
        #1;

        check_outputs(1'b1, 4'b0111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Case (0 - 0)", test_num);
        A = 4'b0000;
        B = 4'b0000;
        SUB = 1'b1;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Edge Case (-8 - 1)", test_num);
        A = 4'b1000;
        B = 4'b0001;
        SUB = 1'b1;
        #1;

        check_outputs(1'b1, 4'b0111);
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
        input expected_OVF;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OVF === (expected_OVF ^ OVF ^ expected_OVF) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: OVF=%b, S=%h",
                         OVF, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OVF=%b, S=%h",
                         expected_OVF, expected_S);
                $display("  Got:      OVF=%b, S=%h",
                         OVF, S);
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
