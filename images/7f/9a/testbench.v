`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg C0;
    reg S0;
    reg S1;
    reg S2;
    reg S3;
    wire [3:0] N1;
    wire [3:0] N2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C0(C0),
        .S0(S0),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .N1(N1),
        .N2(N2)
    );
    task set_inputs;

        input i_C0;
        input [3:0] i_S;
        begin
            C0 = i_C0;
            S3 = i_S[3];
            S2 = i_S[2];
            S1 = i_S[1];
            S0 = i_S[0];
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Value 0 (C0=0, S=0)", test_num);
        set_inputs(0, 4'd0);
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Value 9 (C0=0, S=9)", test_num);
        set_inputs(0, 4'd9);
        #1;

        check_outputs(4'd9, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Value 10 (C0=0, S=10)", test_num);
        set_inputs(0, 4'd10);
        #1;

        check_outputs(4'd0, 4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Value 15 (C0=0, S=15)", test_num);
        set_inputs(0, 4'd15);
        #1;

        check_outputs(4'd5, 4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Value 16 (C0=1, S=0)", test_num);
        set_inputs(1, 4'd0);
        #1;

        check_outputs(4'd6, 4'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Value 19 (C0=1, S=3)", test_num);
        set_inputs(1, 4'd3);
        #1;

        check_outputs(4'd9, 4'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Value 20 (C0=1, S=4)", test_num);
        set_inputs(1, 4'd4);
        #1;

        check_outputs(4'd0, 4'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Value 29 (C0=1, S=13)", test_num);
        set_inputs(1, 4'd13);
        #1;

        check_outputs(4'd9, 4'd2);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Value 30 (C0=1, S=14)", test_num);
        set_inputs(1, 4'd14);
        #1;

        check_outputs(4'd0, 4'd3);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Value 31 (C0=1, S=15)", test_num);
        set_inputs(1, 4'd15);
        #1;

        check_outputs(4'd1, 4'd3);
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
        input [3:0] expected_N1;
        input [3:0] expected_N2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_N1 === (expected_N1 ^ N1 ^ expected_N1) &&
                expected_N2 === (expected_N2 ^ N2 ^ expected_N2)) begin
                $display("PASS");
                $display("  Outputs: N1=%h, N2=%h",
                         N1, N2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: N1=%h, N2=%h",
                         expected_N1, expected_N2);
                $display("  Got:      N1=%h, N2=%h",
                         N1, N2);
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
