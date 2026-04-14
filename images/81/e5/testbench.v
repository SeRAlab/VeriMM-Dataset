`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg [1:0] shift;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .shift(shift),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 4'b1010;
            shift = 2'b00;
            $display("Test Case 001: No Shift (Shift=00, Data=1010)");
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 4'b1100;
            shift = 2'b01;
            $display("Test Case 002: Left Shift 1 (Shift=01, Data=1100)");
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 4'b0011;
            shift = 2'b10;
            $display("Test Case 003: Right Shift 1 (Shift=10, Data=0011)");
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 4'b0101;
            shift = 2'b11;
            $display("Test Case 004: Left Shift 2 (Shift=11, Data=0101)");
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 4'b1111;
            shift = 2'b01;
            $display("Test Case 005: Left Shift 1 All Ones (Shift=01, Data=1111)");
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 4'b1111;
            shift = 2'b10;
            $display("Test Case 006: Right Shift 1 All Ones (Shift=10, Data=1111)");
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 4'b1111;
            shift = 2'b11;
            $display("Test Case 007: Left Shift 2 All Ones (Shift=11, Data=1111)");
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 4'b0000;
            shift = 2'b11;
            $display("Test Case 008: Left Shift 2 All Zeros (Shift=11, Data=0000)");
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data_in = 4'b1001;
            shift = 2'b00;
            $display("Test Case 009: No Shift Boundary (Shift=00, Data=1001)");
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data_in = 4'b0110;
            shift = 2'b01;
            $display("Test Case 010: Left Shift 1 (Shift=01, Data=0110)");
            #1;

            check_outputs(4'b1100);
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
