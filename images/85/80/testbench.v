`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] grf_rs;
    reg [25:0] imm26;
    reg [31:0] pc_F;
    reg [1:0] sel;
    reg [31:0] signextimm16;
    wire [31:0] npc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .grf_rs(grf_rs),
        .imm26(imm26),
        .pc_F(pc_F),
        .sel(sel),
        .signextimm16(signextimm16),
        .npc(npc)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Sequential (sel=00)", test_num);
            pc_F = 32'h0000_1000;
            sel = 2'b00;
            signextimm16 = 32'h0;
            grf_rs = 32'h0;
            imm26 = 26'h0;
            #1;

            check_outputs(32'h0000_1004);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Branch Positive (sel=01)", test_num);
            pc_F = 32'h0000_1000;
            sel = 2'b01;
            signextimm16 = 32'h0000_0005;

            #1;


            check_outputs(32'h0000_1018);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Branch Negative (sel=01)", test_num);
            pc_F = 32'h0000_1000;
            sel = 2'b01;
            signextimm16 = 32'hFFFF_FFFF;

            #1;


            check_outputs(32'h0000_1000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Register Jump (sel=10)", test_num);
            pc_F = 32'h0000_1000;
            sel = 2'b10;
            grf_rs = 32'hABCD_1234;
            #1;

            check_outputs(32'hABCD_1234);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Jump Target (sel=11)", test_num);
            pc_F = 32'hF000_0000;
            sel = 2'b11;
            imm26 = 26'h003_FFFF;


            #1;



            check_outputs(32'hF00F_FFFC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: PC Wrap-around (sel=00)", test_num);
            pc_F = 32'hFFFF_FFFC;
            sel = 2'b00;
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
