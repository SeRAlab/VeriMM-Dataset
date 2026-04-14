`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enableIn;
    reg [31:0] in;
    reg [11:0] rbusCtrl;
    reg reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enableIn(enableIn),
        .in(in),
        .rbusCtrl(rbusCtrl),
        .reset(reset)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            enableIn = 0;
            in = 32'h0;
            rbusCtrl = 12'h000;
            repeat(2) @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Write 32-bit data and read LSB");
            reset_dut();
            in = 32'hAABBCCDD;
            enableIn = 1;
            @(posedge clock);
            enableIn = 0;
            #5;

            rbusCtrl = {8'hAA, 1'b1, 1'b0, 1'b1, 1'b0};
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Sequential access - Read 2nd byte via strobe/clkbus");
            reset_dut();
            in = 32'h12345678;
            enableIn = 1;
            @(posedge clock);
            enableIn = 0;

            rbusCtrl = {8'hAA, 1'b1, 1'b0, 1'b1, 1'b0};
            #10;
            rbusCtrl = {8'hAA, 1'b1, 1'b0, 1'b1, 1'b1};
            #10;
            rbusCtrl = {8'hAA, 1'b1, 1'b0, 1'b1, 1'b0};
            #1;

            check_outputs(8'h56);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Address mismatch - Bus should be High-Z");
            reset_dut();
            in = 32'hFFFFFFFF;
            enableIn = 1;
            @(posedge clock);
            enableIn = 0;

            rbusCtrl = {8'h55, 1'b1, 1'b0, 1'b1, 1'b0};
            #1;

            check_outputs(8'hzz);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Read disabled - Bus should be High-Z");
            reset_dut();
            in = 32'h11223344;
            enableIn = 1;
            @(posedge clock);
            enableIn = 0;

            rbusCtrl = {8'hAA, 1'b0, 1'b0, 1'b1, 1'b0};
            #1;

            check_outputs(8'hzz);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset clearing internal registers");
            reset_dut();

            rbusCtrl = {8'hAA, 1'b1, 1'b0, 1'b1, 1'b0};
            #1;

            check_outputs(8'h00);
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,clock, enableIn, in, rbusCtrl, reset);
    end

endmodule
