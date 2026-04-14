`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] npc4;
    reg [31:0] npcb;
    reg [31:0] npcj;
    reg [31:0] npcjr;
    reg [1:0] npcsrc;
    wire [31:0] npc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .npc4(npc4),
        .npcb(npcb),
        .npcj(npcj),
        .npcjr(npcjr),
        .npcsrc(npcsrc),
        .npc(npc)
    );
    task testcase001;

        begin
            test_num = 1;
            npc4   = 32'h0000_0004;
            npcb   = 32'h1111_1111;
            npcj   = 32'h2222_2222;
            npcjr  = 32'h3333_3333;
            npcsrc = 2'b00;
            $display("Test %0d: Selecting npc4 (npcsrc=00)", test_num);
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            npc4   = 32'hAAAA_AAAA;
            npcb   = 32'h0000_0100;
            npcj   = 32'hBBBB_BBBB;
            npcjr  = 32'hCCCC_CCCC;
            npcsrc = 2'b01;
            $display("Test %0d: Selecting npcb (npcsrc=01)", test_num);
            #1;

            check_outputs(32'h0000_0100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            npc4   = 32'h1234_5678;
            npcb   = 32'h8765_4321;
            npcj   = 32'h0040_0000;
            npcjr  = 32'hFFFF_FFFF;
            npcsrc = 2'b10;
            $display("Test %0d: Selecting npcj (npcsrc=10)", test_num);
            #1;

            check_outputs(32'h0040_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            npc4   = 32'h0000_0000;
            npcb   = 32'h5555_AAAA;
            npcj   = 32'hAAAA_5555;
            npcjr  = 32'h8000_1234;
            npcsrc = 2'b11;
            $display("Test %0d: Selecting npcjr (npcsrc=11)", test_num);
            #1;

            check_outputs(32'h8000_1234);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            npc4   = 32'hFFFF_FFFF;
            npcb   = 32'h0000_0000;
            npcj   = 32'hFFFF_FFFF;
            npcjr  = 32'h0000_0000;

            npcsrc = 2'b00;
            $display("Test %0d: Edge case 1 (npcsrc=00, npc4=all 1s)", test_num);
            #1;

            check_outputs(32'hFFFF_FFFF);

            npcsrc = 2'b01;
            $display("Test %0d: Edge case 2 (npcsrc=01, npcb=all 0s)", test_num);
            #1;

            check_outputs(32'h0000_0000);
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
