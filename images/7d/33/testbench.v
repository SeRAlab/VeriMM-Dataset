`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input_data;
    reg reset;
    wire [2:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_data(input_data),
        .reset(reset),
        .output_data(output_data)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Reset logic");
            test_num = 1;
            reset = 1;
            input_data = 4'b1111;
            #10;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Shift right 4'b1010 (Result: 3'b101)");
            test_num = 2;
            reset = 0;
            input_data = 4'b1010;
            #10;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Shift right 4'b1111 (Result: 3'b111)");
            test_num = 3;
            reset = 0;
            input_data = 4'b1111;
            #10;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Shift right 4'b0001 (Result: 3'b000)");
            test_num = 4;
            reset = 0;
            input_data = 4'b0001;
            #10;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Shift right 4'b0110 (Result: 3'b011)");
            test_num = 5;
            reset = 0;
            input_data = 4'b0110;
            #10;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Verify reset priority over input");
            test_num = 6;
            reset = 0;
            input_data = 4'b1100;
            #5;
            reset = 1;
            #5;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Maximum value shift 4'b1000 (Result: 3'b100)");
            test_num = 7;
            reset = 0;
            input_data = 4'b1000;
            #10;
            #1;

            check_outputs(3'b100);
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
        input [2:0] expected_output_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
