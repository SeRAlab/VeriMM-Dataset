`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] npc;
    reg rst;
    wire [31:0] pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .npc(npc),
        .rst(rst),
        .pc(pc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        npc = 32'h0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Initial Reset Verification", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0000_3000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single NPC Update", test_num);
        reset_dut();
        npc = 32'h0000_3004;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_3004);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multi-Cycle Sequential Update", test_num);
        reset_dut();
        npc = 32'h0000_3004;
        @(posedge clk);
        #1;
        npc = 32'h0000_3008;
        @(posedge clk);
        #1;
        npc = 32'h0000_300C;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_300C);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Priority Over NPC", test_num);
        reset_dut();
        npc = 32'h1234_5678;
        @(posedge clk);
        #1;
        rst = 1;
        npc = 32'hABCD_EF00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_3000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Large Address Jump", test_num);
        reset_dut();
        npc = 32'hFFFF_FFF0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFF_FFF0);
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
        input [31:0] expected_pc;
        begin
            if (expected_pc === (expected_pc ^ pc ^ expected_pc)) begin
                $display("PASS");
                $display("  Outputs: pc=%h",
                         pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc=%h",
                         expected_pc);
                $display("  Got:      pc=%h",
                         pc);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, npc, rst, pc);
    end

endmodule
