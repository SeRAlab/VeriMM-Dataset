`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [31:0] IN;
    reg Load;
    reg Reset;
    wire [31:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .IN(IN),
        .Load(Load),
        .Reset(Reset),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 0;
            Load = 0;
            IN = 0;
            @(negedge Clk);
            Reset = 1;
            @(negedge Clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Functionality");
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Load Operation");
            reset_dut();
            @(negedge Clk);
            IN = 32'hDEADBEEF;
            Load = 1;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load Disable (Data Retention)");
            reset_dut();

            @(negedge Clk);
            IN = 32'h12345678;
            Load = 1;
            @(posedge Clk);

            @(negedge Clk);
            IN = 32'hFFFFFFFF;
            Load = 0;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Consecutive Data Loads");
            reset_dut();
            @(negedge Clk);
            Load = 1;
            IN = 32'hAAAA_AAAA;
            @(posedge Clk);
            @(negedge Clk);
            IN = 32'h5555_5555;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset Priority Check");
            reset_dut();
            @(negedge Clk);
            IN = 32'h8888_8888;
            Load = 1;
            Reset = 0;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Boundary Value (All-Ones)");
            reset_dut();
            @(negedge Clk);
            IN = 32'hFFFF_FFFF;
            Load = 1;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_OUT;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
        $dumpvars(0,Clk, IN, Load, Reset, OUT);
    end

endmodule
