`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] PC_fetch;
    reg clock;
    reg [31:0] instruction_fetch;
    wire [31:0] PC_decode;
    wire [31:0] instruction_decode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC_fetch(PC_fetch),
        .clock(clock),
        .instruction_fetch(instruction_fetch),
        .PC_decode(PC_decode),
        .instruction_decode(instruction_decode)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            instruction_fetch = 0;
            PC_fetch = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            instruction_fetch = 32'hAABBCCDD;
            PC_fetch = 32'h00000004;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h00000004, 32'hAABBCCDD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            instruction_fetch = 32'h00000000;
            PC_fetch = 32'h00000000;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            instruction_fetch = 32'hFFFFFFFF;
            PC_fetch = 32'hFFFFFFFF;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            instruction_fetch = 32'h55555555;
            PC_fetch = 32'hAAAAAAAA;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hAAAAAAAA, 32'h55555555);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            instruction_fetch = 32'h00112233;
            PC_fetch = 32'h00001000;
            @(posedge clock);
            #1;

            instruction_fetch = 32'h44556677;
            PC_fetch = 32'h00001004;
            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h00001004, 32'h44556677);
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
        input [31:0] expected_PC_decode;
        input [31:0] expected_instruction_decode;
        begin
            if (expected_PC_decode === (expected_PC_decode ^ PC_decode ^ expected_PC_decode) &&
                expected_instruction_decode === (expected_instruction_decode ^ instruction_decode ^ expected_instruction_decode)) begin
                $display("PASS");
                $display("  Outputs: PC_decode=%h, instruction_decode=%h",
                         PC_decode, instruction_decode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC_decode=%h, instruction_decode=%h",
                         expected_PC_decode, expected_instruction_decode);
                $display("  Got:      PC_decode=%h, instruction_decode=%h",
                         PC_decode, instruction_decode);
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
        $dumpvars(0,PC_fetch, clock, instruction_fetch, PC_decode, instruction_decode);
    end

endmodule
