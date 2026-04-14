`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] flags;
    reg [7:0] opcode;
    wire [4:0] op_decoder_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .flags(flags),
        .opcode(opcode),
        .op_decoder_out(op_decoder_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Static Opcode Decoding (0x01)", test_num);
        opcode = 8'h01;
        flags = 16'hFFFF;
        #5;
        #1;

        check_outputs(5'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Conditional Opcode (0x02) - Flag[0] is 0", test_num);
        opcode = 8'h02;
        flags = 16'hFFFE;
        #5;
        #1;

        check_outputs(5'h03);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Conditional Opcode (0x02) - Flag[0] is 1", test_num);
        opcode = 8'h02;
        flags = 16'h0001;
        #5;
        #1;

        check_outputs(5'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Conditional Opcode (0x0A) - Flag[15] is 1", test_num);
        opcode = 8'h0A;
        flags = 16'h8000;
        #5;
        #1;

        check_outputs(5'h0A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Unmapped Opcode (Default Case)", test_num);
        opcode = 8'hFF;
        flags = 16'h0000;
        #5;
        #1;

        check_outputs(5'h1F);
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
        input [4:0] expected_op_decoder_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_op_decoder_out === (expected_op_decoder_out ^ op_decoder_out ^ expected_op_decoder_out)) begin
                $display("PASS");
                $display("  Outputs: op_decoder_out=%h",
                         op_decoder_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op_decoder_out=%h",
                         expected_op_decoder_out);
                $display("  Got:      op_decoder_out=%h",
                         op_decoder_out);
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
