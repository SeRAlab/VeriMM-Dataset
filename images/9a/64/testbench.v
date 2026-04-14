`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    wire i0;
    wire i1;
    wire i2;
    wire i3;
    wire i4;
    wire i5;
    wire i6;
    wire i7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .i0(i0),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .i4(i4),
        .i5(i5),
        .i6(i6),
        .i7(i7)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input ABC = 000 (i0 should be HIGH)", test_num);
            A = 0; B = 0; C = 0;
            #1;

            check_outputs(1, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input ABC = 001 (i1 should be HIGH)", test_num);
            A = 0; B = 0; C = 1;
            #1;

            check_outputs(0, 1, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input ABC = 010 (i2 should be HIGH)", test_num);
            A = 0; B = 1; C = 0;
            #1;

            check_outputs(0, 0, 1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Input ABC = 011 (i3 should be HIGH)", test_num);
            A = 0; B = 1; C = 1;
            #1;

            check_outputs(0, 0, 0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Input ABC = 100 (i4 should be HIGH)", test_num);
            A = 1; B = 0; C = 0;
            #1;

            check_outputs(0, 0, 0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Input ABC = 101 (i5 should be HIGH)", test_num);
            A = 1; B = 0; C = 1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Input ABC = 110 (i6 should be HIGH)", test_num);
            A = 1; B = 1; C = 0;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Input ABC = 111 (i7 should be HIGH)", test_num);
            A = 1; B = 1; C = 1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
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
        input expected_i0;
        input expected_i1;
        input expected_i2;
        input expected_i3;
        input expected_i4;
        input expected_i5;
        input expected_i6;
        input expected_i7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i0 === (expected_i0 ^ i0 ^ expected_i0) &&
                expected_i1 === (expected_i1 ^ i1 ^ expected_i1) &&
                expected_i2 === (expected_i2 ^ i2 ^ expected_i2) &&
                expected_i3 === (expected_i3 ^ i3 ^ expected_i3) &&
                expected_i4 === (expected_i4 ^ i4 ^ expected_i4) &&
                expected_i5 === (expected_i5 ^ i5 ^ expected_i5) &&
                expected_i6 === (expected_i6 ^ i6 ^ expected_i6) &&
                expected_i7 === (expected_i7 ^ i7 ^ expected_i7)) begin
                $display("PASS");
                $display("  Outputs: i0=%b, i1=%b, i2=%b, i3=%b, i4=%b, i5=%b, i6=%b, i7=%b",
                         i0, i1, i2, i3, i4, i5, i6, i7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i0=%b, i1=%b, i2=%b, i3=%b, i4=%b, i5=%b, i6=%b, i7=%b",
                         expected_i0, expected_i1, expected_i2, expected_i3, expected_i4, expected_i5, expected_i6, expected_i7);
                $display("  Got:      i0=%b, i1=%b, i2=%b, i3=%b, i4=%b, i5=%b, i6=%b, i7=%b",
                         i0, i1, i2, i3, i4, i5, i6, i7);
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
