`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] instruction;
    wire [25:0] jump_target;
    wire [5:0] opcode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instruction(instruction),
        .jump_target(jump_target),
        .opcode(opcode)
    );
    task testcase001;

    begin
        test_num = 1;
        instruction = 32'h00000000;
        #1;

        check_outputs(26'h0000000, 6'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        instruction = 32'hFFFFFFFF;
        #1;

        check_outputs(26'h3FFFFFF, 6'h3F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        instruction = 32'hA5A5A5A5;
        #1;

        check_outputs(26'h1A5A5A5, 6'h29);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        instruction = 32'h08000001;
        #1;

        check_outputs(26'h0000001, 6'h02);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        instruction = 32'hFC000000;
        #1;

        check_outputs(26'h0000000, 6'h3F);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        instruction = 32'h03FFFFFF;
        #1;

        check_outputs(26'h3FFFFFF, 6'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        instruction = 32'h12345678;
        #1;

        check_outputs(26'h2345678, 6'h04);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        instruction = 32'hEDCBA987;
        #1;

        check_outputs(26'h1CB2A61F & 26'h3FFFFFF, 6'h3B);
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
        input [25:0] expected_jump_target;
        input [5:0] expected_opcode;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_jump_target === (expected_jump_target ^ jump_target ^ expected_jump_target) &&
                expected_opcode === (expected_opcode ^ opcode ^ expected_opcode)) begin
                $display("PASS");
                $display("  Outputs: jump_target=%h, opcode=%h",
                         jump_target, opcode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: jump_target=%h, opcode=%h",
                         expected_jump_target, expected_opcode);
                $display("  Got:      jump_target=%h, opcode=%h",
                         jump_target, opcode);
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
