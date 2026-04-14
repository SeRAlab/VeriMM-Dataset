`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire [1:0] EQ;
    wire [1:0] GT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .EQ(EQ),
        .GT(GT)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=00, B=00 (Full Equality)", test_num);
        A = 2'b00; B = 2'b00;
        #1;

        check_outputs(2'b11, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=11, B=11 (Full Equality)", test_num);
        A = 2'b11; B = 2'b11;
        #1;

        check_outputs(2'b11, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=11, B=00 (A > B bitwise)", test_num);
        A = 2'b11; B = 2'b00;
        #1;

        check_outputs(2'b00, 2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=00, B=11 (A < B bitwise)", test_num);
        A = 2'b00; B = 2'b11;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=10, B=01 (Bitwise mix 1)", test_num);
        A = 2'b10; B = 2'b01;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=01, B=10 (Bitwise mix 2)", test_num);
        A = 2'b01; B = 2'b10;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=11, B=10 (Partial Equality)", test_num);
        A = 2'b11; B = 2'b10;
        #1;

        check_outputs(2'b10, 2'b01);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A=01, B=11 (Partial Equality)", test_num);
        A = 2'b01; B = 2'b11;
        #1;

        check_outputs(2'b01, 2'b00);
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
        input [1:0] expected_EQ;
        input [1:0] expected_GT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EQ === (expected_EQ ^ EQ ^ expected_EQ) &&
                expected_GT === (expected_GT ^ GT ^ expected_GT)) begin
                $display("PASS");
                $display("  Outputs: EQ=%h, GT=%h",
                         EQ, GT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EQ=%h, GT=%h",
                         expected_EQ, expected_GT);
                $display("  Got:      EQ=%h, GT=%h",
                         EQ, GT);
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
