`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg adbginit_l;
    reg rst_l;
    reg se;
    wire adbginit_l_buf;
    wire rst_l_buf;
    wire se_buf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adbginit_l(adbginit_l),
        .rst_l(rst_l),
        .se(se),
        .adbginit_l_buf(adbginit_l_buf),
        .rst_l_buf(rst_l_buf),
        .se_buf(se_buf)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All signals LOW", test_num);
        adbginit_l = 1'b0;
        rst_l = 1'b0;
        se = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All signals HIGH", test_num);
        adbginit_l = 1'b1;
        rst_l = 1'b1;
        se = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: adbginit_l toggled", test_num);
        adbginit_l = 1'b1;
        rst_l = 1'b0;
        se = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: rst_l toggled", test_num);
        adbginit_l = 1'b0;
        rst_l = 1'b1;
        se = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: se toggled", test_num);
        adbginit_l = 1'b0;
        rst_l = 1'b0;
        se = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: se and rst_l HIGH", test_num);
        adbginit_l = 1'b0;
        rst_l = 1'b1;
        se = 1'b1;
        #1;

        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: adbginit_l and se HIGH", test_num);
        adbginit_l = 1'b1;
        rst_l = 1'b0;
        se = 1'b1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: adbginit_l and rst_l HIGH", test_num);
        adbginit_l = 1'b1;
        rst_l = 1'b1;
        se = 1'b0;
        #1;

        check_outputs(1'b1, 1'b1, 1'b0);
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
        input expected_adbginit_l_buf;
        input expected_rst_l_buf;
        input expected_se_buf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adbginit_l_buf === (expected_adbginit_l_buf ^ adbginit_l_buf ^ expected_adbginit_l_buf) &&
                expected_rst_l_buf === (expected_rst_l_buf ^ rst_l_buf ^ expected_rst_l_buf) &&
                expected_se_buf === (expected_se_buf ^ se_buf ^ expected_se_buf)) begin
                $display("PASS");
                $display("  Outputs: adbginit_l_buf=%b, rst_l_buf=%b, se_buf=%b",
                         adbginit_l_buf, rst_l_buf, se_buf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adbginit_l_buf=%b, rst_l_buf=%b, se_buf=%b",
                         expected_adbginit_l_buf, expected_rst_l_buf, expected_se_buf);
                $display("  Got:      adbginit_l_buf=%b, rst_l_buf=%b, se_buf=%b",
                         adbginit_l_buf, rst_l_buf, se_buf);
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
