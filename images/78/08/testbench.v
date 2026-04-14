`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] npc;
    reg resetn;
    reg wpcir;
    wire [31:0] pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .npc(npc),
        .resetn(resetn),
        .wpcir(wpcir),
        .pc(pc)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            npc = 32'h0;
            wpcir = 0;
            @(posedge clock);
            #1;
            resetn = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify reset state (-4)", test_num);
            reset_dut();

            #1;


            check_outputs(32'hFFFFFFFC);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Update PC with npc when wpcir is low", test_num);
            reset_dut();
            npc = 32'h00001000;
            wpcir = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h00001000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PC should retain value when wpcir is high", test_num);
            reset_dut();

            npc = 32'h00002000;
            wpcir = 0;
            @(posedge clock);
            #1;

            npc = 32'h00003000;
            wpcir = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h00002000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple sequential updates", test_num);
            reset_dut();
            wpcir = 0;
            npc = 32'h00000004; @(posedge clock);
            npc = 32'h00000008; @(posedge clock);
            npc = 32'h0000000C; @(posedge clock);
            npc = 32'h00000010; @(posedge clock);
            #1;
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large address and toggle wpcir", test_num);
            reset_dut();
            npc = 32'hABCDE000;
            wpcir = 0;
            @(posedge clock);
            #1;

            wpcir = 1;
            npc = 32'hFFFFFFFF;
            @(posedge clock);
            #1;

            wpcir = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        $dumpvars(0,clock, npc, resetn, wpcir, pc);
    end

endmodule
