`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] PC;
    wire [31:0] NPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC(PC),
        .NPC(NPC)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero value increment", test_num);
            PC = 32'h00000000;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small value increment", test_num);
            PC = 32'h0000000F;
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value overflow", test_num);
            PC = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Halfway boundary increment", test_num);
            PC = 32'h7FFFFFFF;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary pattern increment", test_num);
            PC = 32'hAAAAAAAA;
            #1;

            check_outputs(32'hAAAAAAAB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry propagation check", test_num);
            PC = 32'h0000FFFF;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random value check", test_num);
            PC = 32'h12345678;
            #1;

            check_outputs(32'h12345679);
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
        input [31:0] expected_NPC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_NPC === (expected_NPC ^ NPC ^ expected_NPC)) begin
                $display("PASS");
                $display("  Outputs: NPC=%h",
                         NPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: NPC=%h",
                         expected_NPC);
                $display("  Got:      NPC=%h",
                         NPC);
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
