`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [5:0] lfsr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .lfsr(lfsr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge clk);
            #1;
            $display("Testcase 001: Reset State");
            #1;

            check_outputs(6'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            en = 0;
            repeat(5) @(posedge clk);
            #1;
            $display("Testcase 002: Enable=0 (Hold state)");
            #1;

            check_outputs(6'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            $display("Testcase 003: Sequence Step 1");

            #1;


            check_outputs(6'h24);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            en = 1;
            repeat(2) @(posedge clk);
            #1;
            en = 0;
            $display("Testcase 004: Sequence Step 2");

            #1;


            check_outputs(6'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            en = 1;
            repeat(3) @(posedge clk);
            #1;
            en = 0;
            $display("Testcase 005: Sequence Step 3");

            #1;


            check_outputs(6'h0D);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            repeat(3) @(posedge clk);
            #1;
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            $display("Testcase 006: Intermittent Enable");
            #1;

            check_outputs(6'h12);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            en = 1;
            repeat(4) @(posedge clk);
            #1;
            rst = 1;
            #10;
            rst = 0;
            #1;
            $display("Testcase 007: Mid-sequence Reset");
            #1;

            check_outputs(6'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [5:0] expected_lfsr;
        begin
            if (expected_lfsr === (expected_lfsr ^ lfsr ^ expected_lfsr)) begin
                $display("PASS");
                $display("  Outputs: lfsr=%h",
                         lfsr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr=%h",
                         expected_lfsr);
                $display("  Got:      lfsr=%h",
                         lfsr);
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
        $dumpvars(0,clk, en, rst, lfsr);
    end

endmodule
