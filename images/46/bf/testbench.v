`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] address;
    wire bar_led_ce_n;
    wire board_led_ce_n;
    wire mem1_ce_n;
    wire mem2_ce_n;
    wire switch_ce_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .bar_led_ce_n(bar_led_ce_n),
        .board_led_ce_n(board_led_ce_n),
        .mem1_ce_n(mem1_ce_n),
        .mem2_ce_n(mem2_ce_n),
        .switch_ce_n(switch_ce_n)
    );
    task testcase001;

    begin
        test_num = 1;
        address = 7'b0000000;
        $display("Test Case %0d: Address %b (Expecting switch_ce_n)", test_num, address);

        #1;


        check_outputs(1, 1, 1, 1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        address = 7'b0000001;
        $display("Test Case %0d: Address %b (Expecting bar_led_ce_n)", test_num, address);
        #1;

        check_outputs(0, 1, 1, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        address = 7'b0000010;
        $display("Test Case %0d: Address %b (Expecting board_led_ce_n)", test_num, address);
        #1;

        check_outputs(1, 0, 1, 1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        address = 7'b1000000;
        $display("Test Case %0d: Address %b (Expecting mem1_ce_n range start)", test_num, address);
        #1;

        check_outputs(1, 1, 0, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        address = 7'b1011111;
        $display("Test Case %0d: Address %b (Expecting mem1_ce_n range end)", test_num, address);
        #1;

        check_outputs(1, 1, 0, 1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        address = 7'b1100000;
        $display("Test Case %0d: Address %b (Expecting mem2_ce_n range start)", test_num, address);
        #1;

        check_outputs(1, 1, 1, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        address = 7'b1111111;
        $display("Test Case %0d: Address %b (Expecting mem2_ce_n range end)", test_num, address);
        #1;

        check_outputs(1, 1, 1, 0, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        address = 7'b0000100;
        $display("Test Case %0d: Address %b (Expecting all high/disabled)", test_num, address);
        #1;

        check_outputs(1, 1, 1, 1, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        address = 7'b0111111;
        $display("Test Case %0d: Address %b (Expecting all high/disabled)", test_num, address);
        #1;

        check_outputs(1, 1, 1, 1, 1);
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
        input expected_bar_led_ce_n;
        input expected_board_led_ce_n;
        input expected_mem1_ce_n;
        input expected_mem2_ce_n;
        input expected_switch_ce_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bar_led_ce_n === (expected_bar_led_ce_n ^ bar_led_ce_n ^ expected_bar_led_ce_n) &&
                expected_board_led_ce_n === (expected_board_led_ce_n ^ board_led_ce_n ^ expected_board_led_ce_n) &&
                expected_mem1_ce_n === (expected_mem1_ce_n ^ mem1_ce_n ^ expected_mem1_ce_n) &&
                expected_mem2_ce_n === (expected_mem2_ce_n ^ mem2_ce_n ^ expected_mem2_ce_n) &&
                expected_switch_ce_n === (expected_switch_ce_n ^ switch_ce_n ^ expected_switch_ce_n)) begin
                $display("PASS");
                $display("  Outputs: bar_led_ce_n=%b, board_led_ce_n=%b, mem1_ce_n=%b, mem2_ce_n=%b, switch_ce_n=%b",
                         bar_led_ce_n, board_led_ce_n, mem1_ce_n, mem2_ce_n, switch_ce_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bar_led_ce_n=%b, board_led_ce_n=%b, mem1_ce_n=%b, mem2_ce_n=%b, switch_ce_n=%b",
                         expected_bar_led_ce_n, expected_board_led_ce_n, expected_mem1_ce_n, expected_mem2_ce_n, expected_switch_ce_n);
                $display("  Got:      bar_led_ce_n=%b, board_led_ce_n=%b, mem1_ce_n=%b, mem2_ce_n=%b, switch_ce_n=%b",
                         bar_led_ce_n, board_led_ce_n, mem1_ce_n, mem2_ce_n, switch_ce_n);
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
