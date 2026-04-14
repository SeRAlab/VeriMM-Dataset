`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CE;
    reg CLK;
    reg PRESET;
    reg [15:0] newSP;
    wire [15:0] SP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CE(CE),
        .CLK(CLK),
        .PRESET(PRESET),
        .newSP(newSP),
        .SP(SP)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(posedge CLK);
            PRESET = 1;
            CE = 0;
            newSP = 16'h0000;
            @(posedge CLK);
            #1;
            PRESET = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Verification of PRESET signal");
            reset_dut();

            #1;


            check_outputs(16'hf3ff);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Loading a new value with CE=1");
            reset_dut();
            @(posedge CLK);
            PRESET = 0;
            CE = 1;
            newSP = 16'hABCD;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Clock Enable (CE) low should maintain state");
            reset_dut();
            @(posedge CLK);
            PRESET = 0;
            CE = 0;
            newSP = 16'h1234;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'hf3ff);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: PRESET priority over CE");
            reset_dut();
            @(posedge CLK);
            PRESET = 1;
            CE = 1;
            newSP = 16'h5555;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'hf3ff);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Consecutive updates");
            reset_dut();
            @(posedge CLK);
            CE = 1;
            newSP = 16'h1111;
            @(posedge CLK);
            newSP = 16'h2222;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify state retention after loading");
            reset_dut();

            @(posedge CLK);
            CE = 1;
            newSP = 16'h9999;
            @(posedge CLK);

            CE = 0;
            newSP = 16'hEEEE;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h9999);
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
        input [15:0] expected_SP;
        begin
            if (expected_SP === (expected_SP ^ SP ^ expected_SP)) begin
                $display("PASS");
                $display("  Outputs: SP=%h",
                         SP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SP=%h",
                         expected_SP);
                $display("  Got:      SP=%h",
                         SP);
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
        $dumpvars(0,CE, CLK, PRESET, newSP, SP);
    end

endmodule
