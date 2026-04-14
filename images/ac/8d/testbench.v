`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg S;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        S = 0;
        A = 4'b0000;
        $display("Testcase %0d: S=%b, A=%b (Two's Complement of 0)", test_num, S, A);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        S = 0;
        A = 4'b0001;
        $display("Testcase %0d: S=%b, A=%b (Two's Complement of 1)", test_num, S, A);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        S = 0;
        A = 4'b0111;
        $display("Testcase %0d: S=%b, A=%b (Two's Complement of 7)", test_num, S, A);
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        S = 0;
        A = 4'b1000;
        $display("Testcase %0d: S=%b, A=%b (Two's Complement of -8)", test_num, S, A);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        S = 0;
        A = 4'b1111;
        $display("Testcase %0d: S=%b, A=%b (Two's Complement of -1)", test_num, S, A);
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        S = 1;
        A = 4'b0000;
        $display("Testcase %0d: S=%b, A=%b (One's Complement of 0)", test_num, S, A);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        S = 1;
        A = 4'b1111;
        $display("Testcase %0d: S=%b, A=%b (One's Complement of all 1s)", test_num, S, A);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        S = 1;
        A = 4'b1010;
        $display("Testcase %0d: S=%b, A=%b (One's Complement of 1010)", test_num, S, A);
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        S = 1;
        A = 4'b0101;
        $display("Testcase %0d: S=%b, A=%b (One's Complement of 0101)", test_num, S, A);
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
        testcase008();
        testcase009();
        
        
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
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
