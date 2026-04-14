`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pc;
    wire [15:0] instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pc(pc),
        .instruction(instruction)
    );
    task testcase001;

        begin
            $display("Running testcase001: PC = 0x00 (LOAD)");
            pc = 8'd0;
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: PC = 0x01 (STORE)");
            pc = 8'd1;
            #1;

            check_outputs(16'h0110);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: PC = 0x02 (INC)");
            pc = 8'd2;
            #1;

            check_outputs(16'h0401);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: PC = 0x03 (JUMP)");
            pc = 8'd3;
            #1;

            check_outputs(16'h0501);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: PC = 0x04 (ADD)");
            pc = 8'd4;
            #1;

            check_outputs(16'h0201);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: PC = 0xFF (HALT/Default)");
            pc = 8'hFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: PC = 0x80 (HALT/Default)");
            pc = 8'h80;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_instruction;
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
