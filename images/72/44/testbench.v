`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg inclk;
    reg [31:0] indata;
    reg outclk;
    wire [31:0] outdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inclk(inclk),
        .indata(indata),
        .outclk(outclk),
        .outdata(outdata)
    );

    // Clock generation (10ns period)
    initial begin
        outclk = 0;
        forever #5 outclk = ~outclk;
    end

        task reset_dut;

        begin
            indata = 32'b0;

            repeat(5) @(posedge outclk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Data Capture (A5A5A5A5)", test_num);
            indata = 32'hA5A5_A5A5;



            repeat(10) @(posedge outclk);
            #1;

            check_outputs(32'hA5A5_A5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Capture 5A5A5A5A", test_num);
            indata = 32'h5A5A_5A5A;
            repeat(10) @(posedge outclk);
            #1;

            check_outputs(32'h5A5A_5A5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Capture All Ones (FFFFFFFF)", test_num);
            indata = 32'hFFFF_FFFF;
            repeat(10) @(posedge outclk);
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Capture All Zeros (00000000)", test_num);
            indata = 32'h1234_5678;
            repeat(5) @(posedge outclk);
            indata = 32'h0000_0000;
            repeat(10) @(posedge outclk);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Verification of sequence transfer", test_num);
            indata = 32'hDEAD_BEEF;
            repeat(10) @(posedge outclk);
            #1;

            check_outputs(32'hDEAD_BEEF);
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
        $dumpvars(0,inclk, indata, outclk, outdata);
    end

endmodule
