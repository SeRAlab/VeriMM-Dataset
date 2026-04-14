`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg [1:0] mode;
    wire [9:0] v_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .mode(mode),
        .v_out(v_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 00 - Expected 0V (10'h000)", test_num);
            data_in = 4'b0000;
            mode = 2'b00;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 01 - Expected 1.25V (10'h100)", test_num);
            data_in = 4'b0101;
            mode = 2'b01;
            #1;

            check_outputs(10'h100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 10 - Expected 2.5V (10'h200)", test_num);
            data_in = 4'b1010;
            mode = 2'b10;
            #1;

            check_outputs(10'h200);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 11 - Expected 3.75V (10'h300)", test_num);
            data_in = 4'b1111;
            mode = 2'b11;
            #1;

            check_outputs(10'h300);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify data_in is ignored (Mode 10, different data)", test_num);
            data_in = 4'b0011;
            mode = 2'b10;
            #1;

            check_outputs(10'h200);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify data_in is ignored (Mode 01, different data)", test_num);
            data_in = 4'b1100;
            mode = 2'b01;
            #1;

            check_outputs(10'h100);
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
        input [9:0] expected_v_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_v_out === (expected_v_out ^ v_out ^ expected_v_out)) begin
                $display("PASS");
                $display("  Outputs: v_out=%h",
                         v_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v_out=%h",
                         expected_v_out);
                $display("  Got:      v_out=%h",
                         v_out);
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
