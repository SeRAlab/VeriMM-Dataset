`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] AB;
    reg CLK;
    reg CS;
    reg [7:0] DI;
    reg READ;
    wire [7:0] DO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AB(AB),
        .CLK(CLK),
        .CS(CS),
        .DI(DI),
        .READ(READ),
        .DO(DO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CS = 0;
            AB = 0;
            DI = 0;
            READ = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            CS = 1;
            READ = 0;
            AB = 11'h000;
            DI = 8'h55;
            @(posedge CLK);
            #1;

            READ = 1;
            #2;
            $display("Testcase 001: Basic Write/Read");
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            CS = 1;
            READ = 0;
            AB = 11'h7FF;
            DI = 8'hAA;
            @(posedge CLK);
            #1;

            READ = 1;
            #2;
            $display("Testcase 002: Boundary Address Write/Read");
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            CS = 0;
            AB = 11'h000;
            READ = 1;
            #2;
            $display("Testcase 003: Tri-state Operation (CS=0)");
            #1;

            check_outputs(8'bzzzzzzzz);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            CS = 1; READ = 0; AB = 11'h123; DI = 8'h11;
            @(posedge CLK); #1;

            DI = 8'h22;
            @(posedge CLK); #1;

            READ = 1;
            #2;
            $display("Testcase 004: Overwrite Existing Address");
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            CS = 1; READ = 0; AB = 11'h010; DI = 8'hA1;
            @(posedge CLK); #1;

            AB = 11'h011; DI = 8'hB2;
            @(posedge CLK); #1;

            AB = 11'h010;
            READ = 1;
            #2;
            $display("Testcase 005: Address Independence Check");
            #1;

            check_outputs(8'hA1);
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
        input [7:0] expected_DO;
        begin
            if (expected_DO === (expected_DO ^ DO ^ expected_DO)) begin
                $display("PASS");
                $display("  Outputs: DO=%h",
                         DO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO=%h",
                         expected_DO);
                $display("  Got:      DO=%h",
                         DO);
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
        $dumpvars(0,AB, CLK, CS, DI, READ, DO);
    end

endmodule
