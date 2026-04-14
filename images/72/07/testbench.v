`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] indata;
    reg [15:0] indata180;
    wire [31:0] outdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .indata(indata),
        .indata180(indata180),
        .outdata(outdata)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            indata = 16'h0;
            indata180 = 16'h0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            indata180 = 16'hAAAA;
            indata    = 16'h0000;
            @(posedge clock);
            #1;


            indata180 = 16'hBBBB;
            indata    = 16'h5555;
            @(posedge clock);
            #2;



            $display("Test Case 001: Normal Data Flow");
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            indata180 = 16'h0000;
            indata    = 16'hFFFF;
            @(posedge clock);
            #1;

            indata180 = 16'hFFFF;
            indata    = 16'h0000;
            @(posedge clock);
            #2;

            $display("Test Case 002: Zero and Full Scale Transition");
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            indata180 = 16'hFFFF;
            indata    = 16'h0000;
            @(posedge clock);
            #1;

            indata180 = 16'h0000;
            indata    = 16'hFFFF;
            @(posedge clock);
            #2;

            $display("Test Case 003: High Bit Transition");
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            indata180 = 16'h1234;
            indata    = 16'h0000;
            @(posedge clock);
            #1;

            indata180 = 16'h5678;
            indata    = 16'hABCD;
            @(posedge clock);
            #2;

            $display("Test Case 004: Hex Pattern Test");
            #1;

            check_outputs(32'h1234ABCD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            indata180 = 16'hC0DE;
            @(posedge clock); #1;


            indata180 = 16'hFACE;
            indata    = 16'hBEEF;
            @(posedge clock); #1;


            indata180 = 16'h0000;
            indata    = 16'hCAFE;
            @(posedge clock); #2;

            $display("Test Case 005: Multi-cycle Propagation");

            #1;


            check_outputs(32'hFACECAFE);
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
        input [31:0] expected_outdata;
        begin
            if (expected_outdata === (expected_outdata ^ outdata ^ expected_outdata)) begin
                $display("PASS");
                $display("  Outputs: outdata=%h",
                         outdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outdata=%h",
                         expected_outdata);
                $display("  Got:      outdata=%h",
                         outdata);
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
        $dumpvars(0,clock, indata, indata180, outdata);
    end

endmodule
