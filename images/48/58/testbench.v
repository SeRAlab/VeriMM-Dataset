`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CI;
    wire COUT;
    wire [3:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CI(CI),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Zeros (0 + 0 + 0)", test_num);
        A = 4'd0; B = 4'd0; CI = 1'b0;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Simple addition without carry (5 + 3)", test_num);
        A = 4'd5; B = 4'd3; CI = 1'b0;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Addition with Carry-In (4 + 2 + 1)", test_num);
        A = 4'd4; B = 4'd2; CI = 1'b1;
        #1;

        check_outputs(1'b0, 4'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Sum results in exactly 15 (7 + 8)", test_num);
        A = 4'd7; B = 4'd8; CI = 1'b0;
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Carry-Out only (15 + 1)", test_num);
        A = 4'd15; B = 4'd1; CI = 1'b0;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Maximum possible sum (15 + 15 + 1)", test_num);
        A = 4'd15; B = 4'd15; CI = 1'b1;
        #1;

        check_outputs(1'b1, 4'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Alternating bits (10 + 5)", test_num);
        A = 4'b1010; B = 4'b0101; CI = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Carry propagation through all bits (15 + 0 + 1)", test_num);
        A = 4'd15; B = 4'd0; CI = 1'b1;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Bitwise carry (1 + 1)", test_num);
        A = 4'd1; B = 4'd1; CI = 1'b0;
        #1;

        check_outputs(1'b0, 4'd2);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Large values with carry out (12 + 6)", test_num);
        A = 4'd12; B = 4'd6; CI = 1'b0;
        #1;

        check_outputs(1'b1, 4'd2);
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
        input expected_COUT;
        input [3:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%h",
                         COUT, SUM);
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
