`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    reg rotate_left;
    reg rotate_right;
    reg [1:0] shift;
    reg shift_left;
    reg shift_right;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .rotate_left(rotate_left),
        .rotate_right(rotate_right),
        .shift(shift),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .result(result)
    );
    task testcase001;

        begin
            $display("Testcase001: Default state (No operation selected)");
            data = 4'b1010;
            shift = 2'b01;
            shift_left = 0;
            shift_right = 0;
            rotate_left = 0;
            rotate_right = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Shift Left by 1");
            data = 4'b1011;
            shift = 2'b01;
            shift_left = 1;
            shift_right = 0;
            rotate_left = 0;
            rotate_right = 0;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Shift Left by 2");
            data = 4'b1011;
            shift = 2'b10;
            shift_left = 1;
            shift_right = 0;
            rotate_left = 0;
            rotate_right = 0;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Shift Right by 1");
            data = 4'b1101;
            shift = 2'b01;
            shift_left = 0;
            shift_right = 1;
            rotate_left = 0;
            rotate_right = 0;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Shift Right by 3");
            data = 4'b1101;
            shift = 2'b11;
            shift_left = 0;
            shift_right = 1;
            rotate_left = 0;
            rotate_right = 0;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase006: Rotate Left by 1");
            data = 4'b1011;
            shift = 2'b01;
            shift_left = 0;
            shift_right = 0;
            rotate_left = 1;
            rotate_right = 0;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase007: Rotate Left by 2");
            data = 4'b1011;
            shift = 2'b10;
            shift_left = 0;
            shift_right = 0;
            rotate_left = 1;
            rotate_right = 0;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase008: Rotate Right by 1");
            data = 4'b1011;
            shift = 2'b01;
            shift_left = 0;
            shift_right = 0;
            rotate_left = 0;
            rotate_right = 1;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase009: Rotate Right by 3");
            data = 4'b1011;
            shift = 2'b11;
            shift_left = 0;
            shift_right = 0;
            rotate_left = 0;
            rotate_right = 1;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase010: Shift amount 0 (All controls)");
            data = 4'b1111;
            shift = 2'b00;
            shift_left = 1;
            shift_right = 1;
            rotate_left = 1;
            rotate_right = 1;
            #1;

            check_outputs(4'b1111);
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
        input [3:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
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
