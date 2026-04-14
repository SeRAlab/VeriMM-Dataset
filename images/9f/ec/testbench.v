`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A0;
    reg [3:0] A1;
    reg [3:0] A2;
    reg [3:0] A3;
    reg S0;
    reg S1;
    wire [3:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .S0(S0),
        .S1(S1),
        .X(X)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select A0 (S1S0 = 00)", test_num);
        A0 = 4'hA; A1 = 4'h5; A2 = 4'h3; A3 = 4'hF;
        S1 = 0; S0 = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select A1 (S1S0 = 01)", test_num);
        A0 = 4'hA; A1 = 4'h5; A2 = 4'h3; A3 = 4'hF;
        S1 = 0; S0 = 1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select A2 (S1S0 = 10)", test_num);
        A0 = 4'hA; A1 = 4'h5; A2 = 4'h3; A3 = 4'hF;
        S1 = 1; S0 = 0;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select A3 (S1S0 = 11)", test_num);
        A0 = 4'hA; A1 = 4'h5; A2 = 4'h3; A3 = 4'hF;
        S1 = 1; S0 = 1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select A0 with all inputs same (S1S0 = 00)", test_num);
        A0 = 4'h7; A1 = 4'h7; A2 = 4'h7; A3 = 4'h7;
        S1 = 0; S0 = 0;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select A2 with zero values (S1S0 = 10)", test_num);
        A0 = 4'hF; A1 = 4'hF; A2 = 4'h0; A3 = 4'hF;
        S1 = 1; S0 = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select A3 with bit pattern 1010 (S1S0 = 11)", test_num);
        A0 = 4'h0; A1 = 4'h1; A2 = 4'h2; A3 = 4'b1010;
        S1 = 1; S0 = 1;
        #1;

        check_outputs(4'b1010);
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
        input [3:0] expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%h",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h",
                         expected_X);
                $display("  Got:      X=%h",
                         X);
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
