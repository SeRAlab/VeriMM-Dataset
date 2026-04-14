`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg datain;
    reg reset;
    wire dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .datain(datain),
        .reset(reset),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            datain = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic '111' detection...");
            reset_dut();

            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Overlapping '1111' detection...");
            reset_dut();

            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Interrupted sequence '110111'...");
            reset_dut();

            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);
            datain = 0; @(posedge clock);
            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Incomplete sequence '110'...");
            reset_dut();

            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);
            datain = 0; @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset mid-sequence...");
            reset_dut();

            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);

            reset = 1; @(posedge clock);
            #1 reset = 0;

            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Zeros followed by '111'...");
            reset_dut();
            datain = 0; repeat(3) @(posedge clock);
            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);
            datain = 1; @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
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
        input expected_dataout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%b",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%b",
                         expected_dataout);
                $display("  Got:      dataout=%b",
                         dataout);
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
        $dumpvars(0,clock, datain, reset, dataout);
    end

endmodule
