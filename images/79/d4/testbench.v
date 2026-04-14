`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg y0;
    reg y1;
    reg y2;
    wire one;
    wire sign;
    wire two;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .one(one),
        .sign(sign),
        .two(two)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: y2y1y0 = 000", test_num);
            y2 = 0; y1 = 0; y0 = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: y2y1y0 = 001", test_num);
            y2 = 0; y1 = 0; y0 = 1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: y2y1y0 = 010", test_num);
            y2 = 0; y1 = 1; y0 = 0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: y2y1y0 = 011", test_num);
            y2 = 0; y1 = 1; y0 = 1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: y2y1y0 = 100", test_num);
            y2 = 1; y1 = 0; y0 = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: y2y1y0 = 101", test_num);
            y2 = 1; y1 = 0; y0 = 1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: y2y1y0 = 110", test_num);
            y2 = 1; y1 = 1; y0 = 0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: y2y1y0 = 111", test_num);
            y2 = 1; y1 = 1; y0 = 1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_one;
        input expected_sign;
        input expected_two;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_one === (expected_one ^ one ^ expected_one) &&
                expected_sign === (expected_sign ^ sign ^ expected_sign) &&
                expected_two === (expected_two ^ two ^ expected_two)) begin
                $display("PASS");
                $display("  Outputs: one=%b, sign=%b, two=%b",
                         one, sign, two);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: one=%b, sign=%b, two=%b",
                         expected_one, expected_sign, expected_two);
                $display("  Got:      one=%b, sign=%b, two=%b",
                         one, sign, two);
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
