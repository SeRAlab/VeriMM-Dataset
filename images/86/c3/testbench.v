`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i_data0;
    reg i_data1;
    reg i_data2;
    reg i_data3;
    reg i_select0;
    reg i_select1;
    reg i_select2;
    reg i_select3;
    wire o_data;
    wire o_error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data0(i_data0),
        .i_data1(i_data1),
        .i_data2(i_data2),
        .i_data3(i_data3),
        .i_select0(i_select0),
        .i_select1(i_select1),
        .i_select2(i_select2),
        .i_select3(i_select3),
        .o_data(o_data),
        .o_error(o_error)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data0 (i_select0=1)", test_num);
            i_data0 = 1; i_data1 = 0; i_data2 = 0; i_data3 = 0;
            i_select0 = 1; i_select1 = 0; i_select2 = 0; i_select3 = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data1 (i_select1=1)", test_num);
            i_data0 = 0; i_data1 = 1; i_data2 = 0; i_data3 = 0;
            i_select0 = 0; i_select1 = 1; i_select2 = 0; i_select3 = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data2 (i_select2=1)", test_num);
            i_data0 = 0; i_data1 = 0; i_data2 = 1; i_data3 = 0;
            i_select0 = 0; i_select1 = 0; i_select2 = 1; i_select3 = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data3 (i_select3=1)", test_num);
            i_data0 = 0; i_data1 = 0; i_data2 = 0; i_data3 = 1;
            i_select0 = 0; i_select1 = 0; i_select2 = 0; i_select3 = 1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Error - Multiple select (0 and 1)", test_num);
            i_data0 = 1; i_data1 = 1; i_data2 = 0; i_data3 = 0;
            i_select0 = 1; i_select1 = 1; i_select2 = 0; i_select3 = 0;

            #1;


            check_outputs(o_data, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Error - Multiple select (2 and 3)", test_num);
            i_data0 = 0; i_data1 = 0; i_data2 = 1; i_data3 = 1;
            i_select0 = 0; i_select1 = 0; i_select2 = 1; i_select3 = 1;
            #1;

            check_outputs(o_data, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Error - All select signals high", test_num);
            i_data0 = 1; i_data1 = 1; i_data2 = 1; i_data3 = 1;
            i_select0 = 1; i_select1 = 1; i_select2 = 1; i_select3 = 1;
            #1;

            check_outputs(o_data, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No selection signal active", test_num);
            i_data0 = 1; i_data1 = 1; i_data2 = 1; i_data3 = 1;
            i_select0 = 0; i_select1 = 0; i_select2 = 0; i_select3 = 0;

            #1;


            check_outputs(o_data, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify data pass-through (Logic 0)", test_num);
            i_data0 = 0; i_data1 = 1; i_data2 = 1; i_data3 = 1;
            i_select0 = 1; i_select1 = 0; i_select2 = 0; i_select3 = 0;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_o_data;
        input expected_o_error;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data === (expected_o_data ^ o_data ^ expected_o_data) &&
                expected_o_error === (expected_o_error ^ o_error ^ expected_o_error)) begin
                $display("PASS");
                $display("  Outputs: o_data=%b, o_error=%b",
                         o_data, o_error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data=%b, o_error=%b",
                         expected_o_data, expected_o_error);
                $display("  Got:      o_data=%b, o_error=%b",
                         o_data, o_error);
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
