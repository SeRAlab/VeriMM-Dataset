`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] NPC;
    reg clk;
    reg clrn;
    wire [31:0] PC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .NPC(NPC),
        .clk(clk),
        .clrn(clrn),
        .PC(PC)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clrn = 0;
            NPC = 32'h0;
            @(posedge clk);
            #1;
            clrn = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Load Operation", test_num);
            reset_dut();
            NPC = 32'hA5A5A5A5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Sequential Updates", test_num);
            reset_dut();
            NPC = 32'h00000004;
            @(posedge clk);
            NPC = 32'h00000008;
            @(posedge clk);
            NPC = 32'h0000000C;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000000C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Clear during Operation", test_num);
            reset_dut();
            NPC = 32'hFFFFFFFF;
            @(posedge clk);

            clrn = 0;
            NPC = 32'h12345678;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Value Test (All 1s)", test_num);
            reset_dut();
            NPC = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Recovery from Clear", test_num);
            reset_dut();
            clrn = 0;
            @(posedge clk);
            clrn = 1;
            NPC = 32'hFEEDFACE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFEEDFACE);
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
        input [31:0] expected_PC;
        begin
            if (expected_PC === (expected_PC ^ PC ^ expected_PC)) begin
                $display("PASS");
                $display("  Outputs: PC=%h",
                         PC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC=%h",
                         expected_PC);
                $display("  Got:      PC=%h",
                         PC);
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
        $dumpvars(0,NPC, clk, clrn, PC);
    end

endmodule
