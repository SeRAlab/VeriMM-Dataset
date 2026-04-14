`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    wire [3:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .X(X)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b0000;
        $display("Test %0d: Input A = %b (0)", test_num, A);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'b0001;
        $display("Test %0d: Input A = %b (1)", test_num, A);
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'b0010;
        $display("Test %0d: Input A = %b (2)", test_num, A);
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'b0100;
        $display("Test %0d: Input A = %b (4)", test_num, A);
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'b1000;
        $display("Test %0d: Input A = %b (8)", test_num, A);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b1010;
        $display("Test %0d: Input A = %b (10)", test_num, A);
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'b0101;
        $display("Test %0d: Input A = %b (5)", test_num, A);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'b1111;
        $display("Test %0d: Input A = %b (15)", test_num, A);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'b0111;
        $display("Test %0d: Input A = %b (7)", test_num, A);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'b1100;
        $display("Test %0d: Input A = %b (12)", test_num, A);
        #1;

        check_outputs(4'd12);
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
