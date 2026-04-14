`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg check_stop;
    reg [7:0] rx_data_in;
    reg rx_in;
    wire [7:0] rx_data_out;
    wire stop_bit_error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .check_stop(check_stop),
        .rx_data_in(rx_data_in),
        .rx_in(rx_in),
        .rx_data_out(rx_data_out),
        .stop_bit_error(stop_bit_error)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Valid stop bit (check_stop=1, rx_in=1)");
            check_stop = 1;
            rx_in = 1;
            rx_data_in = 8'hA5;
            #1;

            check_outputs(8'hA5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Stop bit error (check_stop=1, rx_in=0)");
            check_stop = 1;
            rx_in = 0;
            rx_data_in = 8'h5A;
            #1;

            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Check disabled (check_stop=0, rx_in=1)");
            check_stop = 0;
            rx_in = 1;
            rx_data_in = 8'hFF;
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Check disabled (check_stop=0, rx_in=0)");
            check_stop = 0;
            rx_in = 0;
            rx_data_in = 8'h00;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Boundary data pattern with valid stop bit");
            check_stop = 1;
            rx_in = 1;
            rx_data_in = 8'hAA;
            #1;

            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Boundary data pattern with stop bit error");
            check_stop = 1;
            rx_in = 0;
            rx_data_in = 8'hCC;
            #1;

            check_outputs(8'hCC, 1'b1);
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
        input [7:0] expected_rx_data_out;
        input expected_stop_bit_error;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rx_data_out === (expected_rx_data_out ^ rx_data_out ^ expected_rx_data_out) &&
                expected_stop_bit_error === (expected_stop_bit_error ^ stop_bit_error ^ expected_stop_bit_error)) begin
                $display("PASS");
                $display("  Outputs: rx_data_out=%h, stop_bit_error=%b",
                         rx_data_out, stop_bit_error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_data_out=%h, stop_bit_error=%b",
                         expected_rx_data_out, expected_stop_bit_error);
                $display("  Got:      rx_data_out=%h, stop_bit_error=%b",
                         rx_data_out, stop_bit_error);
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
