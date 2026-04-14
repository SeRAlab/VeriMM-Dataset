`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] i_data;
    wire [26:0] o_data_36;
    wire [26:0] o_data_83;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data(i_data),
        .o_data_36(o_data_36),
        .o_data_83(o_data_83)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Zero", test_num);
        i_data = 20'sd0;
        #1;

        check_outputs(27'sd0, 27'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Small Positive (1)", test_num);
        i_data = 20'sd1;
        #1;

        check_outputs(27'sd36, 27'sd83);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Small Negative (-1)", test_num);
        i_data = -20'sd1;
        #1;

        check_outputs(-27'sd36, -27'sd83);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Arbitrary Positive (1234)", test_num);
        i_data = 20'sd1234;
        #1;

        check_outputs(27'sd1234 * 27'sd36, 27'sd1234 * 27'sd83);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Arbitrary Negative (-5678)", test_num);
        i_data = -20'sd5678;
        #1;

        check_outputs(-27'sd5678 * 27'sd36, -27'sd5678 * 27'sd83);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Maximum Positive", test_num);
        i_data = 20'sh7FFFF;
        #1;

        check_outputs(27'sd524287 * 27'sd36, 27'sd524287 * 27'sd83);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input Maximum Negative", test_num);
        i_data = 20'sh80000;
        #1;

        check_outputs(-27'sd524288 * 27'sd36, -27'sd524288 * 27'sd83);
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
        input [26:0] expected_o_data_36;
        input [26:0] expected_o_data_83;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data_36 === (expected_o_data_36 ^ o_data_36 ^ expected_o_data_36) &&
                expected_o_data_83 === (expected_o_data_83 ^ o_data_83 ^ expected_o_data_83)) begin
                $display("PASS");
                $display("  Outputs: o_data_36=%h, o_data_83=%h",
                         o_data_36, o_data_83);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data_36=%h, o_data_83=%h",
                         expected_o_data_36, expected_o_data_83);
                $display("  Got:      o_data_36=%h, o_data_83=%h",
                         o_data_36, o_data_83);
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
