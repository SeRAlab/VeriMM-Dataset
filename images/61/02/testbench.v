`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CIN;
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
        .CIN(CIN),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b0000;
        B = 4'b0000;
        CIN = 1'b0;
        $display("Testcase %0d: All inputs zero", test_num);
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd5;
        B = 4'd3;
        CIN = 1'b0;
        $display("Testcase %0d: A=5, B=3, CIN=0 (Sum=8, No COUT)", test_num);
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd2;
        B = 4'd4;
        CIN = 1'b1;
        $display("Testcase %0d: A=2, B=4, CIN=1 (Sum=7, No COUT)", test_num);
        #1;

        check_outputs(1'b0, 4'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd10;
        B = 4'd5;
        CIN = 1'b0;
        $display("Testcase %0d: A=10, B=5, CIN=0 (Sum=15, No COUT)", test_num);
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd8;
        B = 4'd8;
        CIN = 1'b0;
        $display("Testcase %0d: A=8, B=8, CIN=0 (Sum=0, COUT=1)", test_num);
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd15;
        B = 4'd0;
        CIN = 1'b1;
        $display("Testcase %0d: A=15, B=0, CIN=1 (Sum=0, COUT=1)", test_num);
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd15;
        B = 4'd15;
        CIN = 1'b1;
        $display("Testcase %0d: A=15, B=15, CIN=1 (Sum=15, COUT=1)", test_num);
        #1;

        check_outputs(1'b1, 4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'b1010;
        B = 4'b0101;
        CIN = 1'b1;
        $display("Testcase %0d: A=10, B=5, CIN=1 (Sum=0, COUT=1)", test_num);
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'b1111;
        B = 4'b0000;
        CIN = 1'b1;
        $display("Testcase %0d: Propagation (1111 + 0001)", test_num);
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'd7;
        B = 4'd9;
        CIN = 1'b1;
        $display("Testcase %0d: A=7, B=9, CIN=1 (Sum=1, COUT=1)", test_num);
        #1;

        check_outputs(1'b1, 4'd1);
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
