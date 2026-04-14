`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg iqSel;
    reg reset;
    reg [11:0] sig_in;
    reg strobe;
    wire [11:0] dcoffset;
    wire [11:0] sigout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .iqSel(iqSel),
        .reset(reset),
        .sig_in(sig_in),
        .strobe(strobe),
        .dcoffset(dcoffset),
        .sigout(sigout)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            strobe = 0;
            iqSel = 0;
            sig_in = 0;
            @(posedge clock);
            #2 reset = 0;
            @(posedge clock);
        end
        endtask
    task drive_cycle;

        input sel;
        input signed [11:0] val;
        input en;
        begin
            @(posedge clock);
            iqSel = sel;
            sig_in = val;
            strobe = en;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Verifying Reset State");
            reset_dut();

            #1;


            check_outputs(12'sh0, 12'sh0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Path 0 Basic Integration");
            reset_dut();
            drive_cycle(0, 12'sh010, 1);
            @(negedge clock);
            #1;

            #1;


            check_outputs(12'sh010, 12'sh000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Path 1 Integration");
            reset_dut();
            drive_cycle(1, 12'sh020, 1);
            @(negedge clock);
            #1;

            #1;


            check_outputs(12'sh020, 12'sh000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Strobe Gating Check");
            reset_dut();
            drive_cycle(0, 12'sh015, 1);
            @(negedge clock);
            drive_cycle(0, 12'sh050, 0);
            @(negedge clock);
            #1;

            #1;


            check_outputs(12'sh015, 12'sh03B);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Dual Path Independence");
            reset_dut();

            drive_cycle(0, 12'sh005, 1);
            @(negedge clock);

            drive_cycle(1, 12'sh00A, 1);
            @(negedge clock);

            drive_cycle(0, 12'sh005, 0);
            @(negedge clock);
            #1;

            #1;


            check_outputs(12'sh005, 12'sh000);
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
        input [11:0] expected_dcoffset;
        input [11:0] expected_sigout;
        begin
            if (expected_dcoffset === (expected_dcoffset ^ dcoffset ^ expected_dcoffset) &&
                expected_sigout === (expected_sigout ^ sigout ^ expected_sigout)) begin
                $display("PASS");
                $display("  Outputs: dcoffset=%h, sigout=%h",
                         dcoffset, sigout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dcoffset=%h, sigout=%h",
                         expected_dcoffset, expected_sigout);
                $display("  Got:      dcoffset=%h, sigout=%h",
                         dcoffset, sigout);
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
        $dumpvars(0,clock, iqSel, reset, sig_in, strobe, dcoffset, sigout);
    end

endmodule
