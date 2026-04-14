`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] npc;
    reg pc_en;
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
        .pc_en(pc_en),
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
            pc_en = 0;
            npc = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic PC Update (pc_en=1)", test_num);
            reset_dut();
            npc = 32'h00000004;
            pc_en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: PC Update Disabled (pc_en=0)", test_num);
            reset_dut();
            npc = 32'h00000008;
            pc_en = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Value on pc_en Transition", test_num);
            reset_dut();

            npc = 32'h12345678;
            pc_en = 1;
            @(posedge clk);
            #1;

            pc_en = 0;
            npc = 32'hABCDEF00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Address Update", test_num);
            reset_dut();
            npc = 32'hFFFFFFF8;
            pc_en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFF8);
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
        $dumpvars(0,clk, npc, pc_en, rst, pc);
    end

endmodule
