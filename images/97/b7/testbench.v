`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg branch;
    reg en_fetch;
    reg [3:0] opcode;
    wire pc0;
    wire pc_sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branch(branch),
        .en_fetch(en_fetch),
        .opcode(opcode),
        .pc0(pc0),
        .pc_sel(pc_sel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fetch Disabled", test_num);
            en_fetch = 0;
            branch = 1;
            opcode = 4'b0001;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fetch Enabled, Specific Opcode (1111)", test_num);
            en_fetch = 1;
            branch = 1;
            opcode = 4'b1111;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fetch Enabled, Valid Opcode, Branch High", test_num);
            en_fetch = 1;
            branch = 1;
            opcode = 4'b0101;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fetch Enabled, Valid Opcode, Branch Low", test_num);
            en_fetch = 1;
            branch = 0;
            opcode = 4'b0011;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fetch Enabled, Opcode 0000, Branch High", test_num);
            en_fetch = 1;
            branch = 1;
            opcode = 4'b0000;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_pc0;
        input expected_pc_sel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pc0 === (expected_pc0 ^ pc0 ^ expected_pc0) &&
                expected_pc_sel === (expected_pc_sel ^ pc_sel ^ expected_pc_sel)) begin
                $display("PASS");
                $display("  Outputs: pc0=%b, pc_sel=%b",
                         pc0, pc_sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc0=%b, pc_sel=%b",
                         expected_pc0, expected_pc_sel);
                $display("  Got:      pc0=%b, pc_sel=%b",
                         pc0, pc_sel);
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
