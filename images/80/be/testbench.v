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
            test_num = 1;
            $display("Test %0d: PC at lower boundary (0x00)", test_num);
            pc = 8'h00;


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: PC in middle of valid range (0x05)", test_num);
            pc = 8'h05;

            #1;


            check_outputs(16'h0005);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: PC at upper boundary of valid range (0x0C)", test_num);
            pc = 8'h0C;

            #1;


            check_outputs(16'h000C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: PC just outside valid range (0x0D)", test_num);
            pc = 8'h0D;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: PC at maximum value (0xFF)", test_num);
            pc = 8'hFF;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Random invalid address (0x55)", test_num);
            pc = 8'h55;
            #1;

            check_outputs(16'hFFFF);
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
