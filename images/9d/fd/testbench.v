`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i_Switch_1;
    reg i_Switch_2;
    reg i_Switch_3;
    reg i_Switch_4;
    wire o_LED_1;
    wire o_LED_2;
    wire o_LED_3;
    wire o_LED_4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_Switch_1(i_Switch_1),
        .i_Switch_2(i_Switch_2),
        .i_Switch_3(i_Switch_3),
        .i_Switch_4(i_Switch_4),
        .o_LED_1(o_LED_1),
        .o_LED_2(o_LED_2),
        .o_LED_3(o_LED_3),
        .o_LED_4(o_LED_4)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Switches OFF", test_num);
        i_Switch_1 = 1'b0;
        i_Switch_2 = 1'b0;
        i_Switch_3 = 1'b0;
        i_Switch_4 = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Switches ON", test_num);
        i_Switch_1 = 1'b1;
        i_Switch_2 = 1'b1;
        i_Switch_3 = 1'b1;
        i_Switch_4 = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 1010", test_num);
        i_Switch_1 = 1'b1;
        i_Switch_2 = 1'b0;
        i_Switch_3 = 1'b1;
        i_Switch_4 = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0110", test_num);
        i_Switch_1 = 1'b0;
        i_Switch_2 = 1'b1;
        i_Switch_3 = 1'b1;
        i_Switch_4 = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single bit walking (Switch 1)", test_num);
        i_Switch_1 = 1'b1;
        i_Switch_2 = 1'b0;
        i_Switch_3 = 1'b0;
        i_Switch_4 = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single bit walking (Switch 2)", test_num);
        i_Switch_1 = 1'b0;
        i_Switch_2 = 1'b1;
        i_Switch_3 = 1'b0;
        i_Switch_4 = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single bit walking (Switch 3)", test_num);
        i_Switch_1 = 1'b0;
        i_Switch_2 = 1'b0;
        i_Switch_3 = 1'b1;
        i_Switch_4 = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single bit walking (Switch 4)", test_num);
        i_Switch_1 = 1'b0;
        i_Switch_2 = 1'b0;
        i_Switch_3 = 1'b0;
        i_Switch_4 = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
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
        input expected_o_LED_1;
        input expected_o_LED_2;
        input expected_o_LED_3;
        input expected_o_LED_4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_LED_1 === (expected_o_LED_1 ^ o_LED_1 ^ expected_o_LED_1) &&
                expected_o_LED_2 === (expected_o_LED_2 ^ o_LED_2 ^ expected_o_LED_2) &&
                expected_o_LED_3 === (expected_o_LED_3 ^ o_LED_3 ^ expected_o_LED_3) &&
                expected_o_LED_4 === (expected_o_LED_4 ^ o_LED_4 ^ expected_o_LED_4)) begin
                $display("PASS");
                $display("  Outputs: o_LED_1=%b, o_LED_2=%b, o_LED_3=%b, o_LED_4=%b",
                         o_LED_1, o_LED_2, o_LED_3, o_LED_4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_LED_1=%b, o_LED_2=%b, o_LED_3=%b, o_LED_4=%b",
                         expected_o_LED_1, expected_o_LED_2, expected_o_LED_3, expected_o_LED_4);
                $display("  Got:      o_LED_1=%b, o_LED_2=%b, o_LED_3=%b, o_LED_4=%b",
                         o_LED_1, o_LED_2, o_LED_3, o_LED_4);
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
