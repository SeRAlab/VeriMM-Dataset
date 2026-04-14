`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] instruction;
    reg [31:0] pc;
    wire [31:0] instout;
    wire [31:0] pcout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .instruction(instruction),
        .pc(pc),
        .instout(instout),
        .pcout(pcout)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            instruction = 32'b0;
            pc = 32'b0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase001: Basic instruction and PC capture");
            reset_dut();
            instruction = 32'hAABBCCDD;
            pc = 32'h00001000;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hAABBCCDD, 32'h00001000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase002: Maximum values (All 1s)");
            reset_dut();
            instruction = 32'hFFFFFFFF;
            pc = 32'hFFFFFFFF;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase003: Minimum values (All 0s)");
            reset_dut();

            instruction = 32'h00000000;
            pc = 32'h00000000;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase004: Alternating bit patterns");
            reset_dut();
            instruction = 32'h55555555;
            pc = 32'hAAAAAAAA;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h55555555, 32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running testcase005: Sequential update verification");
            reset_dut();

            instruction = 32'h12345678;
            pc = 32'h00000004;
            @(posedge clock);
            #1;

            instruction = 32'h87654321;
            pc = 32'h00000008;
            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h87654321, 32'h00000008);
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
        input [31:0] expected_instout;
        input [31:0] expected_pcout;
        begin
            if (expected_instout === (expected_instout ^ instout ^ expected_instout) &&
                expected_pcout === (expected_pcout ^ pcout ^ expected_pcout)) begin
                $display("PASS");
                $display("  Outputs: instout=%h, pcout=%h",
                         instout, pcout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instout=%h, pcout=%h",
                         expected_instout, expected_pcout);
                $display("  Got:      instout=%h, pcout=%h",
                         instout, pcout);
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
        $dumpvars(0,clock, instruction, pc, instout, pcout);
    end

endmodule
