`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] pc;
    wire [31:0] npc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pc(pc),
        .npc(npc)
    );
    task testcase001;

        begin
            test_num = 1;
            pc = 32'h00000000;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            pc = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            pc = 32'h00001000;
            #1;

            check_outputs(32'h00001001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            pc = 32'h000000FF;
            #1;

            check_outputs(32'h00000100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            pc = 32'h12345678;
            #1;

            check_outputs(32'h12345679);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            pc = 32'h7FFFFFFF;
            #1;

            check_outputs(32'h80000000);
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
        input [31:0] expected_npc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_npc === (expected_npc ^ npc ^ expected_npc)) begin
                $display("PASS");
                $display("  Outputs: npc=%h",
                         npc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: npc=%h",
                         expected_npc);
                $display("  Got:      npc=%h",
                         npc);
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
