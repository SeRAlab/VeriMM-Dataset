`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a__1;
    reg a__3;
    reg a__4;
    reg a__5;
    reg a__6;
    reg b__1;
    reg b__2;
    wire n__258;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a__1(a__1),
        .a__3(a__3),
        .a__4(a__4),
        .a__5(a__5),
        .a__6(a__6),
        .b__1(b__1),
        .b__2(b__2),
        .n__258(n__258)
    );
    task testcase001;

        begin
            test_num = 1;
            {a__1, a__3, a__4, a__5, a__6, b__1, b__2} = 7'b0000000;
            #1;

            check_outputs(calc_expected(a__5, a__4, b__2, a__1, b__1, a__3, a__6));
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            {a__1, a__3, a__4, a__5, a__6, b__1, b__2} = 7'b1111111;
            #1;

            check_outputs(calc_expected(a__5, a__4, b__2, a__1, b__1, a__3, a__6));
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a__5 = 1; a__4 = 1; b__2 = 1;
            a__1 = 0; b__1 = 0; a__3 = 0; a__6 = 0;
            #1;

            check_outputs(calc_expected(a__5, a__4, b__2, a__1, b__1, a__3, a__6));
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a__5 = 0; a__4 = 0; b__2 = 0;
            a__1 = 1; b__1 = 1; a__3 = 1; a__6 = 1;
            #1;

            check_outputs(calc_expected(a__5, a__4, b__2, a__1, b__1, a__3, a__6));
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            {a__1, a__3, a__4, a__5, a__6, b__1, b__2} = 7'b1010101;
            #1;

            check_outputs(calc_expected(a__5, a__4, b__2, a__1, b__1, a__3, a__6));
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            {a__1, a__3, a__4, a__5, a__6, b__1, b__2} = 7'b0101010;
            #1;

            check_outputs(calc_expected(a__5, a__4, b__2, a__1, b__1, a__3, a__6));
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            {a__1, a__3, a__4, a__5, a__6, b__1, b__2} = 7'b1000000;
            #1;

            check_outputs(calc_expected(a__5, a__4, b__2, a__1, b__1, a__3, a__6));
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            {a__1, a__3, a__4, a__5, a__6, b__1, b__2} = 7'b0000001;
            #1;

            check_outputs(calc_expected(a__5, a__4, b__2, a__1, b__1, a__3, a__6));
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a__1=1; a__3=1; a__4=1; a__5=1; a__6=1;
            b__1=0; b__2=0;
            #1;

            check_outputs(calc_expected(a__5, a__4, b__2, a__1, b__1, a__3, a__6));
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a__1=0; a__3=0; a__4=0; a__5=0; a__6=0;
            b__1=1; b__2=1;
            #1;

            check_outputs(calc_expected(a__5, a__4, b__2, a__1, b__1, a__3, a__6));
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
        input expected_n__258;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n__258 === (expected_n__258 ^ n__258 ^ expected_n__258)) begin
                $display("PASS");
                $display("  Outputs: n__258=%b",
                         n__258);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n__258=%b",
                         expected_n__258);
                $display("  Got:      n__258=%b",
                         n__258);
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
