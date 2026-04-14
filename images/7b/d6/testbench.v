`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg pfc_inst_nop_i;
    reg [31:0] pm_inst_bus_i;
    wire [31:0] pm_inst_bus_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pfc_inst_nop_i(pfc_inst_nop_i),
        .pm_inst_bus_i(pm_inst_bus_i),
        .pm_inst_bus_o(pm_inst_bus_o)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pass-through mode - Pattern A", test_num);
        pfc_inst_nop_i = 1'b0;
        pm_inst_bus_i = 32'hAAAAAAAA;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pass-through mode - Pattern B", test_num);
        pfc_inst_nop_i = 1'b0;
        pm_inst_bus_i = 32'h55555555;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: NOP mode - Force NOP with non-zero input", test_num);
        pfc_inst_nop_i = 1'b1;
        pm_inst_bus_i = 32'hDEADBEEF;
        #1;

        check_outputs(NOP_INSTRUCTION);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: NOP mode - Force NOP with zero input", test_num);
        pfc_inst_nop_i = 1'b1;
        pm_inst_bus_i = 32'h00000000;
        #1;

        check_outputs(NOP_INSTRUCTION);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pass-through mode - Random instruction", test_num);
        pfc_inst_nop_i = 1'b0;
        pm_inst_bus_i = 32'h12345678;
        #1;

        check_outputs(32'h12345678);
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
        input [31:0] expected_pm_inst_bus_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pm_inst_bus_o === (expected_pm_inst_bus_o ^ pm_inst_bus_o ^ expected_pm_inst_bus_o)) begin
                $display("PASS");
                $display("  Outputs: pm_inst_bus_o=%h",
                         pm_inst_bus_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pm_inst_bus_o=%h",
                         expected_pm_inst_bus_o);
                $display("  Got:      pm_inst_bus_o=%h",
                         pm_inst_bus_o);
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
