`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Jump_Control;
    reg [31:0] Jump_Instruction;
    reg [31:0] Multiplexer_Instruction;
    wire [31:0] New_PC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Jump_Control(Jump_Control),
        .Jump_Instruction(Jump_Instruction),
        .Multiplexer_Instruction(Multiplexer_Instruction),
        .New_PC(New_PC)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Multiplexer_Instruction (Jump_Control = 0)", test_num);
            Jump_Control = 1'b0;
            Multiplexer_Instruction = 32'h1234_5678;
            Jump_Instruction = 32'hABCD_EF01;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Jump_Instruction (Jump_Control = 1)", test_num);
            Jump_Control = 1'b1;
            Multiplexer_Instruction = 32'h1234_5678;
            Jump_Instruction = 32'hABCD_EF01;
            #1;

            check_outputs(32'hABCD_EF01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros on inputs, Jump_Control = 0", test_num);
            Jump_Control = 1'b0;
            Multiplexer_Instruction = 32'h0000_0000;
            Jump_Instruction = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones on inputs, Jump_Control = 1", test_num);
            Jump_Control = 1'b1;
            Multiplexer_Instruction = 32'h0000_0000;
            Jump_Instruction = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bit patterns, Jump_Control = 0", test_num);
            Jump_Control = 1'b0;
            Multiplexer_Instruction = 32'hAAAA_AAAA;
            Jump_Instruction = 32'h5555_5555;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bit patterns, Jump_Control = 1", test_num);
            Jump_Control = 1'b1;
            Multiplexer_Instruction = 32'hAAAA_AAAA;
            Jump_Instruction = 32'h5555_5555;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Specific PC address check", test_num);
            Jump_Control = 1'b1;
            Multiplexer_Instruction = 32'h0000_0004;
            Jump_Instruction = 32'h0040_0000;
            #1;

            check_outputs(32'h0040_0000);
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
        input [31:0] expected_New_PC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_New_PC === (expected_New_PC ^ New_PC ^ expected_New_PC)) begin
                $display("PASS");
                $display("  Outputs: New_PC=%h",
                         New_PC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: New_PC=%h",
                         expected_New_PC);
                $display("  Got:      New_PC=%h",
                         New_PC);
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
