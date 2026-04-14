`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] opcode;
    wire [1:0] mem_sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .opcode(opcode),
        .mem_sel(mem_sel)
    );
    task testcase001;

        begin
            test_num = 1;
            opcode = 6'h28;
            $display("Test %0d: Testing Opcode 6'h28 (Expected mem_sel = 2'b00)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            opcode = 6'h29;
            $display("Test %0d: Testing Opcode 6'h29 (Expected mem_sel = 2'b01)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            opcode = 6'h38;
            $display("Test %0d: Testing Opcode 6'h38 (Expected mem_sel = 2'b10)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            opcode = 6'h00;
            $display("Test %0d: Testing Default Opcode 6'h00 (Expected mem_sel = 2'b11)", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            opcode = 6'h15;
            $display("Test %0d: Testing Random Opcode 6'h15 (Expected mem_sel = 2'b11)", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            opcode = 6'h3F;
            $display("Test %0d: Testing Edge Opcode 6'h3F (Expected mem_sel = 2'b11)", test_num);
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_mem_sel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mem_sel === (expected_mem_sel ^ mem_sel ^ expected_mem_sel)) begin
                $display("PASS");
                $display("  Outputs: mem_sel=%h",
                         mem_sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_sel=%h",
                         expected_mem_sel);
                $display("  Got:      mem_sel=%h",
                         mem_sel);
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
