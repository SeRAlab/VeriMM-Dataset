`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] imm;
    wire [31:0] e_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .imm(imm),
        .e_out(e_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: imm = 16'h0000 (Zero)", test_num);
        imm = 16'h0000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: imm = 16'h7FFF (Max Positive)", test_num);
        imm = 16'h7FFF;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: imm = 16'h8000 (Min Negative)", test_num);
        imm = 16'h8000;
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: imm = 16'hFFFF (-1)", test_num);
        imm = 16'hFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: imm = 16'h1234 (Positive pattern)", test_num);
        imm = 16'h1234;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: imm = 16'hA5A5 (Negative pattern)", test_num);
        imm = 16'hA5A5;
        #1;

        check_outputs(32'hFFFFA5A5);
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
        input [31:0] expected_e_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_e_out === (expected_e_out ^ e_out ^ expected_e_out)) begin
                $display("PASS");
                $display("  Outputs: e_out=%h",
                         e_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e_out=%h",
                         expected_e_out);
                $display("  Got:      e_out=%h",
                         e_out);
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
