`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk_6hz;
    reg [7:0] iic_sel;
    reg jtag_sel;
    reg rst_n;
    reg scl;
    wire jtag_con;
    wire jtag_sys;
    wire led_test0;
    wire lm80_reset_n;
    wire scl0;
    wire scl1;
    wire scl2;
    wire scl3;
    wire scl4;
    wire scl5;
    wire scl6;
    wire scl7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_6hz(clk_6hz),
        .iic_sel(iic_sel),
        .jtag_sel(jtag_sel),
        .rst_n(rst_n),
        .scl(scl),
        .jtag_con(jtag_con),
        .jtag_sys(jtag_sys),
        .led_test0(led_test0),
        .lm80_reset_n(lm80_reset_n),
        .scl0(scl0),
        .scl1(scl1),
        .scl2(scl2),
        .scl3(scl3),
        .scl4(scl4),
        .scl5(scl5),
        .scl6(scl6),
        .scl7(scl7)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: System Reset State", test_num);


        rst_n = 1'b0;
        clk_6hz = 1'b0;
        jtag_sel = 1'b0;
        iic_sel = 8'h00;
        scl = 1'b1;

        #10;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: JTAG Selection and LED Toggle", test_num);

        rst_n = 1'b1;
        clk_6hz = 1'b1;
        jtag_sel = 1'b1;
        iic_sel = 8'h00;
        scl = 1'b1;

        #10;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1, 1'b1, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: I2C SCL Routing - Channel 0", test_num);

        rst_n = 1'b1;
        clk_6hz = 1'b0;
        jtag_sel = 1'b0;
        iic_sel = 8'h01;
        scl = 1'b1;

        #10;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: I2C SCL Routing - Channel 3 (SCL Low)", test_num);

        rst_n = 1'b1;
        clk_6hz = 1'b1;
        jtag_sel = 1'b0;
        iic_sel = 8'h08;
        scl = 1'b0;

        #10;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'bz, 1'bz, 1'bz, 1'b0, 1'bz, 1'bz, 1'bz, 1'bz);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: I2C SCL Routing - Channel 7", test_num);

        rst_n = 1'b1;
        clk_6hz = 1'b0;
        jtag_sel = 1'b1;
        iic_sel = 8'h80;
        scl = 1'b1;

        #10;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'b1);
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
        input expected_jtag_con;
        input expected_jtag_sys;
        input expected_led_test0;
        input expected_lm80_reset_n;
        input expected_scl0;
        input expected_scl1;
        input expected_scl2;
        input expected_scl3;
        input expected_scl4;
        input expected_scl5;
        input expected_scl6;
        input expected_scl7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_jtag_con === (expected_jtag_con ^ jtag_con ^ expected_jtag_con) &&
                expected_jtag_sys === (expected_jtag_sys ^ jtag_sys ^ expected_jtag_sys) &&
                expected_led_test0 === (expected_led_test0 ^ led_test0 ^ expected_led_test0) &&
                expected_lm80_reset_n === (expected_lm80_reset_n ^ lm80_reset_n ^ expected_lm80_reset_n) &&
                expected_scl0 === (expected_scl0 ^ scl0 ^ expected_scl0) &&
                expected_scl1 === (expected_scl1 ^ scl1 ^ expected_scl1) &&
                expected_scl2 === (expected_scl2 ^ scl2 ^ expected_scl2) &&
                expected_scl3 === (expected_scl3 ^ scl3 ^ expected_scl3) &&
                expected_scl4 === (expected_scl4 ^ scl4 ^ expected_scl4) &&
                expected_scl5 === (expected_scl5 ^ scl5 ^ expected_scl5) &&
                expected_scl6 === (expected_scl6 ^ scl6 ^ expected_scl6) &&
                expected_scl7 === (expected_scl7 ^ scl7 ^ expected_scl7)) begin
                $display("PASS");
                $display("  Outputs: jtag_con=%b, jtag_sys=%b, led_test0=%b, lm80_reset_n=%b, scl0=%b, scl1=%b, scl2=%b, scl3=%b, scl4=%b, scl5=%b, scl6=%b, scl7=%b",
                         jtag_con, jtag_sys, led_test0, lm80_reset_n, scl0, scl1, scl2, scl3, scl4, scl5, scl6, scl7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: jtag_con=%b, jtag_sys=%b, led_test0=%b, lm80_reset_n=%b, scl0=%b, scl1=%b, scl2=%b, scl3=%b, scl4=%b, scl5=%b, scl6=%b, scl7=%b",
                         expected_jtag_con, expected_jtag_sys, expected_led_test0, expected_lm80_reset_n, expected_scl0, expected_scl1, expected_scl2, expected_scl3, expected_scl4, expected_scl5, expected_scl6, expected_scl7);
                $display("  Got:      jtag_con=%b, jtag_sys=%b, led_test0=%b, lm80_reset_n=%b, scl0=%b, scl1=%b, scl2=%b, scl3=%b, scl4=%b, scl5=%b, scl6=%b, scl7=%b",
                         jtag_con, jtag_sys, led_test0, lm80_reset_n, scl0, scl1, scl2, scl3, scl4, scl5, scl6, scl7);
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
