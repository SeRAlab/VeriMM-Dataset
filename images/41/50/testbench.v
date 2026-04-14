`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctrl_sel_0;
    reg ctrl_sel_1;
    reg data_in_0;
    reg data_in_1;
    reg data_in_2;
    reg data_in_3;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl_sel_0(ctrl_sel_0),
        .ctrl_sel_1(ctrl_sel_1),
        .data_in_0(data_in_0),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .data_in_3(data_in_3),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select data_in_0 with value 1", test_num);
        data_in_0 = 1; data_in_1 = 0; data_in_2 = 0; data_in_3 = 0;
        ctrl_sel_1 = 0; ctrl_sel_0 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select data_in_0 with value 0", test_num);
        data_in_0 = 0; data_in_1 = 1; data_in_2 = 1; data_in_3 = 1;
        ctrl_sel_1 = 0; ctrl_sel_0 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select data_in_1 with value 1", test_num);
        data_in_0 = 0; data_in_1 = 1; data_in_2 = 0; data_in_3 = 0;
        ctrl_sel_1 = 0; ctrl_sel_0 = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select data_in_1 with value 0", test_num);
        data_in_0 = 1; data_in_1 = 0; data_in_2 = 1; data_in_3 = 1;
        ctrl_sel_1 = 0; ctrl_sel_0 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Select data_in_2 with value 1", test_num);
        data_in_0 = 0; data_in_1 = 0; data_in_2 = 1; data_in_3 = 0;
        ctrl_sel_1 = 1; ctrl_sel_0 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Select data_in_2 with value 0", test_num);
        data_in_0 = 1; data_in_1 = 1; data_in_2 = 0; data_in_3 = 1;
        ctrl_sel_1 = 1; ctrl_sel_0 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Select data_in_3 with value 1", test_num);
        data_in_0 = 0; data_in_1 = 0; data_in_2 = 0; data_in_3 = 1;
        ctrl_sel_1 = 1; ctrl_sel_0 = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Select data_in_3 with value 0", test_num);
        data_in_0 = 1; data_in_1 = 1; data_in_2 = 1; data_in_3 = 0;
        ctrl_sel_1 = 1; ctrl_sel_0 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Rapid input switching (interference check)", test_num);
        data_in_0 = 0; data_in_1 = 1; data_in_2 = 0; data_in_3 = 1;
        ctrl_sel_1 = 0; ctrl_sel_0 = 1;
        #5;
        data_in_0 = 1; data_in_2 = 1; data_in_3 = 0;
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
        input expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
                         data_out);
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
