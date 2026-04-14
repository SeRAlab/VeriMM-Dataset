`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Address;
    wire [31:0] Instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .Instruction(Instruction)
    );
    task testcase001;

    begin
        test_num = 1;
        Address = 32'h00000000;
        #1;

        check_outputs(INST0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Address = 32'h00000004;
        #1;

        check_outputs(INST1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Address = 32'h00000008;
        #1;

        check_outputs(INST2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Address = 32'h0000000C;
        #1;

        check_outputs(INST3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Address = 32'h00000010;
        #1;

        check_outputs(INST4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Address = 32'h00000014;
        #1;

        check_outputs(DEFAULT);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Address = 32'h0000FFFF;
        #1;

        check_outputs(DEFAULT);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Address = 32'h00000003;



        #1;




        check_outputs(INST0);
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
        input [31:0] expected_Instruction;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Instruction === (expected_Instruction ^ Instruction ^ expected_Instruction)) begin
                $display("PASS");
                $display("  Outputs: Instruction=%h",
                         Instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Instruction=%h",
                         expected_Instruction);
                $display("  Got:      Instruction=%h",
                         Instruction);
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
