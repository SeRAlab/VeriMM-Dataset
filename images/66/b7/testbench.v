`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_bus;
    reg [2:0] shift_amount;
    reg shift_direction;
    wire [7:0] output_bus;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_bus(input_bus),
        .shift_amount(shift_amount),
        .shift_direction(shift_direction),
        .output_bus(output_bus)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase 001: Left Shift by 0 (Amount 0, Direction 0)");
            input_bus = 8'hFF;
            shift_amount = 3'd0;
            shift_direction = 1'b0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase 002: Left Shift by 1 (A5 << 1)");
            input_bus = 8'hA5;
            shift_amount = 3'd1;
            shift_direction = 1'b0;
            #1;

            check_outputs(8'h4A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase 003: Left Shift by 4 (A5 << 4)");
            input_bus = 8'hA5;
            shift_amount = 3'd4;
            shift_direction = 1'b0;
            #1;

            check_outputs(8'h50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase 004: Left Shift by 7 (A5 << 7)");
            input_bus = 8'hA5;
            shift_amount = 3'd7;
            shift_direction = 1'b0;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase 005: Right Shift by 0 (Amount 0, Direction 1)");
            input_bus = 8'hFF;
            shift_amount = 3'd0;
            shift_direction = 1'b1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase 006: Right Shift by 1 (A5 >> 1)");
            input_bus = 8'hA5;
            shift_amount = 3'd1;
            shift_direction = 1'b1;
            #1;

            check_outputs(8'h52);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase 007: Right Shift by 4 (A5 >> 4)");
            input_bus = 8'hA5;
            shift_amount = 3'd4;
            shift_direction = 1'b1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase 008: Right Shift by 7 (A5 >> 7)");
            input_bus = 8'hA5;
            shift_amount = 3'd7;
            shift_direction = 1'b1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase 009: Left Shift FF by 3");
            input_bus = 8'hFF;
            shift_amount = 3'd3;
            shift_direction = 1'b0;
            #1;

            check_outputs(8'hF8);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase 010: Right Shift FF by 3");
            input_bus = 8'hFF;
            shift_amount = 3'd3;
            shift_direction = 1'b1;
            #1;

            check_outputs(8'h1F);
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
        input [7:0] expected_output_bus;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_bus === (expected_output_bus ^ output_bus ^ expected_output_bus)) begin
                $display("PASS");
                $display("  Outputs: output_bus=%h",
                         output_bus);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_bus=%h",
                         expected_output_bus);
                $display("  Got:      output_bus=%h",
                         output_bus);
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
