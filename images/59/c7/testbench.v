`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire [1:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Input in range 0-2 (0)");
        data_in = 4'd0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Input in range 0-2 (2)");
        data_in = 4'd2;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Input in range 3-5 (3)");
        data_in = 4'd3;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Input in range 3-5 (5)");
        data_in = 4'd5;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Input in range 6-8 (6)");
        data_in = 4'd6;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Input in range 6-8 (8)");
        data_in = 4'd8;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Input in range 9-11 (9)");
        data_in = 4'd9;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Input in range 9-11 (11)");
        data_in = 4'd11;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Input out of range (12)");
        data_in = 4'd12;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Input out of range (15)");
        data_in = 4'd15;
        #1;

        check_outputs(2'b00);
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
        testcase010();
        
        
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
        input [1:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
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
