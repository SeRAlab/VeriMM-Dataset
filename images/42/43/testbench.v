`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Ctrl;
    reg [15:0] Imm16;
    wire [31:0] BusImm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ctrl(Ctrl),
        .Imm16(Imm16),
        .BusImm(BusImm)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        
        
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
        input [31:0] expected_BusImm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BusImm === (expected_BusImm ^ BusImm ^ expected_BusImm)) begin
                $display("PASS");
                $display("  Outputs: BusImm=%h",
                         BusImm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BusImm=%h",
                         expected_BusImm);
                $display("  Got:      BusImm=%h",
                         BusImm);
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
