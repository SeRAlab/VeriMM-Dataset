`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg data0;
    reg data1;
    reg data10;
    reg data11;
    reg data12;
    reg data13;
    reg data14;
    reg data15;
    reg data16;
    reg data17;
    reg data18;
    reg data19;
    reg data2;
    reg data3;
    reg data4;
    reg data5;
    reg data6;
    reg data7;
    reg data8;
    reg data9;
    wire result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0(data0),
        .data1(data1),
        .data10(data10),
        .data11(data11),
        .data12(data12),
        .data13(data13),
        .data14(data14),
        .data15(data15),
        .data16(data16),
        .data17(data17),
        .data18(data18),
        .data19(data19),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .data6(data6),
        .data7(data7),
        .data8(data8),
        .data9(data9),
        .result(result)
    );
    task set_all_inputs;

        input val;
        begin
            data0 = val;  data1 = val;  data2 = val;  data3 = val;
            data4 = val;  data5 = val;  data6 = val;  data7 = val;
            data8 = val;  data9 = val;  data10 = val; data11 = val;
            data12 = val; data13 = val; data14 = val; data15 = val;
            data16 = val; data17 = val; data18 = val; data19 = val;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs LOW", test_num);
            set_all_inputs(1'b0);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs HIGH", test_num);
            set_all_inputs(1'b1);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only data0 LOW", test_num);
            set_all_inputs(1'b1);
            data0 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only data19 LOW", test_num);
            set_all_inputs(1'b1);
            data19 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only data10 LOW", test_num);
            set_all_inputs(1'b1);
            data10 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple LOW inputs", test_num);
            set_all_inputs(1'b0);
            data0 = 1'b1;
            data5 = 1'b1;
            data15 = 1'b1;
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
        input expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%b",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%b",
                         expected_result);
                $display("  Got:      result=%b",
                         result);
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
