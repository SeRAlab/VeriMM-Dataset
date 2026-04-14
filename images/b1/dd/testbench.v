`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] filter_select_balance;
    reg [1:0] filter_select_identify;
    reg ready;
    wire [1:0] filter_select_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .filter_select_balance(filter_select_balance),
        .filter_select_identify(filter_select_identify),
        .ready(ready),
        .filter_select_out(filter_select_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select balance when ready is LOW", test_num);
            ready = 1'b0;
            filter_select_balance = 2'b01;
            filter_select_identify = 2'b10;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select identify when ready is HIGH", test_num);
            ready = 1'b1;
            filter_select_balance = 2'b01;
            filter_select_identify = 2'b10;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select balance (All High)", test_num);
            ready = 1'b0;
            filter_select_balance = 2'b11;
            filter_select_identify = 2'b00;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select identify (All High)", test_num);
            ready = 1'b1;
            filter_select_balance = 2'b00;
            filter_select_identify = 2'b11;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Balance input change reflected while ready is LOW", test_num);
            ready = 1'b0;
            filter_select_identify = 2'b11;
            filter_select_balance = 2'b10;
            #5;
            filter_select_balance = 2'b00;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Identify input change reflected while ready is HIGH", test_num);
            ready = 1'b1;
            filter_select_balance = 2'b11;
            filter_select_identify = 2'b01;
            #5;
            filter_select_identify = 2'b10;
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_filter_select_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_filter_select_out === (expected_filter_select_out ^ filter_select_out ^ expected_filter_select_out)) begin
                $display("PASS");
                $display("  Outputs: filter_select_out=%h",
                         filter_select_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: filter_select_out=%h",
                         expected_filter_select_out);
                $display("  Got:      filter_select_out=%h",
                         filter_select_out);
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
