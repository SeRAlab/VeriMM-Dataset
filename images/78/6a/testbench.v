`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [29:0] NPC;
    reg PCWr;
    reg clk;
    reg rst;
    wire [29:0] PC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .NPC(NPC),
        .PCWr(PCWr),
        .clk(clk),
        .rst(rst),
        .PC(PC)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            NPC = 30'h0;
            PCWr = 0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Reset (PC should be 0x3000)", test_num);
            reset_dut();

            #1;


            check_outputs(30'h3000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: PCWr = 1, NPC = 0x1234", test_num);
            reset_dut();
            @(negedge clk);
            NPC = 30'h1234;
            PCWr = 1;
            @(negedge clk);
            #1;

            check_outputs(30'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: PCWr = 0, NPC = 0x5555 (PC should stay 0x3000)", test_num);
            reset_dut();
            @(negedge clk);
            NPC = 30'h5555;
            PCWr = 0;
            @(negedge clk);
            #1;

            check_outputs(30'h3000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sequential updates", test_num);
            reset_dut();
            @(negedge clk);
            PCWr = 1;
            NPC = 30'hA;
            @(negedge clk);
            NPC = 30'hB;
            @(negedge clk);
            NPC = 30'hC;
            @(negedge clk);
            #1;

            check_outputs(30'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Max Address Value", test_num);
            reset_dut();
            @(negedge clk);
            PCWr = 1;
            NPC = 30'h3FFFFFFF;
            @(negedge clk);
            #1;

            check_outputs(30'h3FFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Toggle PCWr", test_num);
            reset_dut();
            @(negedge clk);
            PCWr = 1;
            NPC = 30'h100;
            @(negedge clk);
            PCWr = 0;
            NPC = 30'h200;
            @(negedge clk);
            #1;

            check_outputs(30'h100);
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
        input [29:0] expected_PC;
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
        $dumpvars(0,NPC, PCWr, clk, rst, PC);
    end

endmodule
