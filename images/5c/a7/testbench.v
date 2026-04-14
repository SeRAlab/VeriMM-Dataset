`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [34:0] A;
    reg [34:0] B;
    reg CI;
    wire CO;
    wire [34:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CI(CI),
        .CO(CO),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Add (10 + 20, CI=0)", test_num);
        A = 35'h00000000A;
        B = 35'h000000014;
        CI = 1'b0;
        #1;

        check_outputs(1'b0, 35'h00000001E);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Add with Carry-In (15 + 5, CI=1)", test_num);
        A = 35'h00000000F;
        B = 35'h000000005;
        CI = 1'b1;
        #1;

        check_outputs(1'b0, 35'h000000015);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum 8-bit sum (200 + 55, CI=0)", test_num);
        A = 35'h0000000C8;
        B = 35'h000000037;
        CI = 1'b0;
        #1;

        check_outputs(1'b0, 35'h0000000FF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry-Out Check (255 + 1, CI=0)", test_num);
        A = 35'h0000000FF;
        B = 35'h000000001;
        CI = 1'b0;
        #1;

        check_outputs(1'b1, 35'h000000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Inputs (255 + 255, CI=1)", test_num);
        A = 35'h0000000FF;
        B = 35'h0000000FF;
        CI = 1'b1;
        #1;

        check_outputs(1'b1, 35'h0000000FF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero addition", test_num);
        A = 35'h000000000;
        B = 35'h000000000;
        CI = 1'b0;
        #1;

        check_outputs(1'b0, 35'h000000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: CI result only", test_num);
        A = 35'h000000000;
        B = 35'h000000000;
        CI = 1'b1;
        #1;

        check_outputs(1'b0, 35'h000000001);
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
        input expected_CO;
        input [34:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, SUM=%h",
                         CO, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, SUM=%h",
                         expected_CO, expected_SUM);
                $display("  Got:      CO=%b, SUM=%h",
                         CO, SUM);
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
