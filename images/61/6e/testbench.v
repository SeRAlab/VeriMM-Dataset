`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire o1;
    wire o2;
    wire o3;
    wire o4;
    wire o5;
    wire o6;
    wire o7;
    wire o8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .o4(o4),
        .o5(o5),
        .o6(o6),
        .o7(o7),
        .o8(o8)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Verifying initial constant output values", test_num);

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Verifying output stability after time delay", test_num);
            #100;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Verifying output stability after longer time delay", test_num);
            #500;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0);
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
        input expected_o1;
        input expected_o2;
        input expected_o3;
        input expected_o4;
        input expected_o5;
        input expected_o6;
        input expected_o7;
        input expected_o8;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_o4 === (expected_o4 ^ o4 ^ expected_o4) &&
                expected_o5 === (expected_o5 ^ o5 ^ expected_o5) &&
                expected_o6 === (expected_o6 ^ o6 ^ expected_o6) &&
                expected_o7 === (expected_o7 ^ o7 ^ expected_o7) &&
                expected_o8 === (expected_o8 ^ o8 ^ expected_o8)) begin
                $display("PASS");
                $display("  Outputs: o1=%b, o2=%b, o3=%b, o4=%b, o5=%b, o6=%b, o7=%b, o8=%b",
                         o1, o2, o3, o4, o5, o6, o7, o8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o1=%b, o2=%b, o3=%b, o4=%b, o5=%b, o6=%b, o7=%b, o8=%b",
                         expected_o1, expected_o2, expected_o3, expected_o4, expected_o5, expected_o6, expected_o7, expected_o8);
                $display("  Got:      o1=%b, o2=%b, o3=%b, o4=%b, o5=%b, o6=%b, o7=%b, o8=%b",
                         o1, o2, o3, o4, o5, o6, o7, o8);
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
