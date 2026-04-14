`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a__1;
    reg b__0;
    reg b__2;
    reg b__3;
    reg b__4;
    reg c;
    wire n__115;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a__1(a__1),
        .b__0(b__0),
        .b__2(b__2),
        .b__3(b__3),
        .b__4(b__4),
        .c(c),
        .n__115(n__115)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All inputs Zero", test_num);
            a__1 = 0; b__0 = 0; b__2 = 0; b__3 = 0; b__4 = 0; c = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All inputs One (Condition Met)", test_num);
            a__1 = 1; b__0 = 1; b__2 = 1; b__3 = 1; b__4 = 1; c = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Only b__4 is Zero", test_num);
            a__1 = 1; b__0 = 1; b__2 = 1; b__3 = 1; b__4 = 0; c = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Only b__2 is Zero", test_num);
            a__1 = 1; b__0 = 1; b__2 = 0; b__3 = 1; b__4 = 1; c = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Only a__1 is Zero", test_num);
            a__1 = 0; b__0 = 1; b__2 = 1; b__3 = 1; b__4 = 1; c = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Only b__0 is Zero", test_num);
            a__1 = 1; b__0 = 0; b__2 = 1; b__3 = 1; b__4 = 1; c = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Only c is Zero", test_num);
            a__1 = 1; b__0 = 1; b__2 = 1; b__3 = 1; b__4 = 1; c = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Only b__3 is Zero", test_num);
            a__1 = 1; b__0 = 1; b__2 = 1; b__3 = 0; b__4 = 1; c = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Alternating Bits", test_num);
            a__1 = 1; b__0 = 0; b__2 = 1; b__3 = 0; b__4 = 1; c = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Random Pattern", test_num);
            a__1 = 0; b__0 = 1; b__2 = 0; b__3 = 1; b__4 = 0; c = 1;
            #1;

            check_outputs(1'b1);
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
        input expected_n__115;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n__115 === (expected_n__115 ^ n__115 ^ expected_n__115)) begin
                $display("PASS");
                $display("  Outputs: n__115=%b",
                         n__115);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n__115=%b",
                         expected_n__115);
                $display("  Got:      n__115=%b",
                         n__115);
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
