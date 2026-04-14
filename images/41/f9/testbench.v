`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a__2;
    reg a__6;
    reg b__2;
    reg b__3;
    reg b__4;
    reg b__5;
    wire n__359;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a__2(a__2),
        .a__6(a__6),
        .b__2(b__2),
        .b__3(b__3),
        .b__4(b__4),
        .b__5(b__5),
        .n__359(n__359)
    );
    task testcase001;

        begin
            test_num = 1;
            a__2 = 0; a__6 = 0; b__2 = 0; b__3 = 0; b__4 = 0; b__5 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a__2 = 1; a__6 = 1; b__2 = 1; b__3 = 1; b__4 = 1; b__5 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a__2 = 1; a__6 = 1; b__2 = 0; b__3 = 0; b__4 = 0; b__5 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a__2 = 0; a__6 = 0; b__2 = 1; b__3 = 1; b__4 = 1; b__5 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a__2 = 0; a__6 = 1; b__2 = 1; b__3 = 1; b__4 = 1; b__5 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a__2 = 1; a__6 = 0; b__2 = 1; b__3 = 1; b__4 = 1; b__5 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a__2 = 1; a__6 = 1; b__2 = 0; b__3 = 1; b__4 = 1; b__5 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a__2 = 1; a__6 = 1; b__2 = 1; b__3 = 1; b__4 = 1; b__5 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a__2 = 1; a__6 = 0; b__2 = 1; b__3 = 0; b__4 = 1; b__5 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a__2 = 0; a__6 = 1; b__2 = 1; b__3 = 0; b__4 = 1; b__5 = 1;
            #1;

            check_outputs(1'b0);
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
        input expected_n__359;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n__359 === (expected_n__359 ^ n__359 ^ expected_n__359)) begin
                $display("PASS");
                $display("  Outputs: n__359=%b",
                         n__359);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n__359=%b",
                         expected_n__359);
                $display("  Got:      n__359=%b",
                         n__359);
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
