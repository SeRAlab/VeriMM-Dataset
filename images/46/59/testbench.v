`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] readAddress;
    wire [31:0] instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .readAddress(readAddress),
        .instruction(instruction)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            readAddress = 32'h0000_0000;
            #10;
            $display("Test Case 001: Reading from Address 0x0");
            #1;

            check_outputs(32'h00000821);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            readAddress = 32'h0000_0004;
            #10;
            $display("Test Case 002: Reading from Address 0x4");
            #1;

            check_outputs(32'h00004921);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            readAddress = 32'h0000_0008;
            #10;
            $display("Test Case 003: Reading from Address 0x8");
            #1;

            check_outputs(32'h01294020);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            readAddress = 32'h0000_000C;
            #10;
            $display("Test Case 004: Reading from Address 0xC");
            #1;

            check_outputs(32'hAC080020);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            readAddress = 32'h0000_0010;
            #10;
            $display("Test Case 005: Reading from Address 0x10");
            #1;

            check_outputs(32'h03E00008);
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
        input [31:0] expected_instruction;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_instruction === (expected_instruction ^ instruction ^ expected_instruction)) begin
                $display("PASS");
                $display("  Outputs: instruction=%h",
                         instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction=%h",
                         expected_instruction);
                $display("  Got:      instruction=%h",
                         instruction);
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
