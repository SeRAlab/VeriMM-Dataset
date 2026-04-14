`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] DATAIN;
    reg [1:0] MODE;
    reg clock;
    reg reset;
    wire [3:0] DATAOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATAIN(DATAIN),
        .MODE(MODE),
        .clock(clock),
        .reset(reset),
        .DATAOUT(DATAOUT)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            reset = 1;
            MODE = 2'b00;
            DATAIN = 4'b0000;
            @(negedge clock);
            reset = 0;
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Reset...");
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking Parallel Load (MODE=3)...");
            reset_dut();
            MODE = 2'b11; DATAIN = 4'b1010;
            @(negedge clock);
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking Hold Data (MODE=0)...");
            reset_dut();

            MODE = 2'b11; DATAIN = 4'b0111; @(negedge clock);

            MODE = 2'b00; DATAIN = 4'b1111; @(negedge clock);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking Right Shift (Fill 0)...");
            reset_dut();

            MODE = 2'b11; DATAIN = 4'b1000; @(negedge clock);

            MODE = 2'b01; DATAIN = 4'b0000; @(negedge clock);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking Left Shift (Fill 0)...");
            reset_dut();

            MODE = 2'b11; DATAIN = 4'b0001; @(negedge clock);

            MODE = 2'b10; DATAIN = 4'b0000; @(negedge clock);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Checking Right Shift (Fill 1)...");
            reset_dut();

            MODE = 2'b11; DATAIN = 4'b0101; @(negedge clock);

            MODE = 2'b01; DATAIN = 4'b0001; @(negedge clock);
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Checking Left Shift (Fill 1)...");
            reset_dut();

            MODE = 2'b11; DATAIN = 4'b1010; @(negedge clock);

            MODE = 2'b10; DATAIN = 4'b0001; @(negedge clock);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Checking Continuous Left Shift...");
            reset_dut();
            MODE = 2'b10; DATAIN = 4'b0001; @(negedge clock);
            MODE = 2'b10; DATAIN = 4'b0001; @(negedge clock);
            MODE = 2'b10; DATAIN = 4'b0000; @(negedge clock);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Checking Complex Mode Transitions...");
            reset_dut();
            MODE = 2'b11; DATAIN = 4'b1010; @(negedge clock);
            MODE = 2'b00; DATAIN = 4'b1111; @(negedge clock);
            MODE = 2'b01; DATAIN = 4'b0000; @(negedge clock);
            MODE = 2'b11; DATAIN = 4'b1111; @(negedge clock);
            MODE = 2'b10; DATAIN = 4'b0000; @(negedge clock);
            #1;

            check_outputs(4'b1110);
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
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [3:0] expected_DATAOUT;
        begin
            if (expected_DATAOUT === (expected_DATAOUT ^ DATAOUT ^ expected_DATAOUT)) begin
                $display("PASS");
                $display("  Outputs: DATAOUT=%h",
                         DATAOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATAOUT=%h",
                         expected_DATAOUT);
                $display("  Got:      DATAOUT=%h",
                         DATAOUT);
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
        $dumpvars(0,DATAIN, MODE, clock, reset, DATAOUT);
    end

endmodule
