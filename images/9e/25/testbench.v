`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i_a;
    reg i_b;
    reg i_sel;
    wire o_led;
    wire o_led1;
    wire o_led2;
    wire o_led3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_a(i_a),
        .i_b(i_b),
        .i_sel(i_sel),
        .o_led(o_led),
        .o_led1(o_led1),
        .o_led2(o_led2),
        .o_led3(o_led3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: i_sel=0, i_a=0, i_b=0", test_num);
        i_sel = 1'b0; i_a = 1'b0; i_b = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: i_sel=0, i_a=1, i_b=0", test_num);
        i_sel = 1'b0; i_a = 1'b1; i_b = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: i_sel=0, i_a=0, i_b=1", test_num);
        i_sel = 1'b0; i_a = 1'b0; i_b = 1'b1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: i_sel=0, i_a=1, i_b=1", test_num);
        i_sel = 1'b0; i_a = 1'b1; i_b = 1'b1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: i_sel=1, i_a=0, i_b=0", test_num);
        i_sel = 1'b1; i_a = 1'b0; i_b = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: i_sel=1, i_a=1, i_b=0", test_num);
        i_sel = 1'b1; i_a = 1'b1; i_b = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: i_sel=1, i_a=0, i_b=1", test_num);
        i_sel = 1'b1; i_a = 1'b0; i_b = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: i_sel=1, i_a=1, i_b=1", test_num);
        i_sel = 1'b1; i_a = 1'b1; i_b = 1'b1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
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
        input expected_o_led;
        input expected_o_led1;
        input expected_o_led2;
        input expected_o_led3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_led === (expected_o_led ^ o_led ^ expected_o_led) &&
                expected_o_led1 === (expected_o_led1 ^ o_led1 ^ expected_o_led1) &&
                expected_o_led2 === (expected_o_led2 ^ o_led2 ^ expected_o_led2) &&
                expected_o_led3 === (expected_o_led3 ^ o_led3 ^ expected_o_led3)) begin
                $display("PASS");
                $display("  Outputs: o_led=%b, o_led1=%b, o_led2=%b, o_led3=%b",
                         o_led, o_led1, o_led2, o_led3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_led=%b, o_led1=%b, o_led2=%b, o_led3=%b",
                         expected_o_led, expected_o_led1, expected_o_led2, expected_o_led3);
                $display("  Got:      o_led=%b, o_led1=%b, o_led2=%b, o_led3=%b",
                         o_led, o_led1, o_led2, o_led3);
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
