`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg empty;
    reg free2;
    reg free3;
    reg [1:0] tm_count;
    wire [4:0] fifocount_inc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .empty(empty),
        .free2(free2),
        .free3(free3),
        .tm_count(tm_count),
        .fifocount_inc(fifocount_inc)
    );
    task testcase001;

    begin
        test_num = 1;
        empty = 1'b1;
        free2 = 1'b0;
        free3 = 1'b0;
        tm_count = 2'b00;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        empty = 1'b1;
        free2 = 1'b1;
        free3 = 1'b1;
        tm_count = 2'b11;
        #1;

        check_outputs(5'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        empty = 1'b0;
        free2 = 1'b1;
        free3 = 1'b0;
        tm_count = 2'b00;
        #1;

        check_outputs(5'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        empty = 1'b0;
        free2 = 1'b1;
        free3 = 1'b1;
        tm_count = 2'b01;
        #1;

        check_outputs(5'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        empty = 1'b0;
        free2 = 1'b0;
        free3 = 1'b1;
        tm_count = 2'b10;
        #1;

        check_outputs(5'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        empty = 1'b0;
        free2 = 1'b0;
        free3 = 1'b0;
        tm_count = 2'b11;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        empty = 1'b1;
        free2 = 1'b0;
        free3 = 1'b0;
        tm_count = 2'b10;
        #1;

        check_outputs(5'd2);
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
        input [4:0] expected_fifocount_inc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fifocount_inc === (expected_fifocount_inc ^ fifocount_inc ^ expected_fifocount_inc)) begin
                $display("PASS");
                $display("  Outputs: fifocount_inc=%h",
                         fifocount_inc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifocount_inc=%h",
                         expected_fifocount_inc);
                $display("  Got:      fifocount_inc=%h",
                         fifocount_inc);
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
