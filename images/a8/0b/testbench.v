`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire sink_eop;
    wire sink_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .sink_eop(sink_eop),
        .sink_sop(sink_sop)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking SOP immediately after reset (Counter=0)");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking outputs at Counter=1");
            test_num = 2;
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Checking EOP at Counter=1023");
            test_num = 3;
            reset_dut();
            for (i = 0; i < 1023; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Checking outputs at Counter=1024");
            test_num = 4;
            reset_dut();
            for (i = 0; i < 1024; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Checking wrap-around reset at 1030 (Next state 0)");
            test_num = 5;
            reset_dut();

            for (i = 0; i < 1031; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Mid-sequence reset check");
            test_num = 6;
            reset_dut();

            for (i = 0; i < 500; i = i + 1) begin
                @(posedge clk);
            end

            reset_dut();

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("Testcase 007: Checking outputs at Counter=1030");
            test_num = 7;
            reset_dut();
            for (i = 0; i < 1030; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(0, 0);
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
        input expected_sink_eop;
        input expected_sink_sop;
        begin
            if (expected_sink_eop === (expected_sink_eop ^ sink_eop ^ expected_sink_eop) &&
                expected_sink_sop === (expected_sink_sop ^ sink_sop ^ expected_sink_sop)) begin
                $display("PASS");
                $display("  Outputs: sink_eop=%b, sink_sop=%b",
                         sink_eop, sink_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sink_eop=%b, sink_sop=%b",
                         expected_sink_eop, expected_sink_sop);
                $display("  Got:      sink_eop=%b, sink_sop=%b",
                         sink_eop, sink_sop);
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
        $dumpvars(0,clk, rst_n, sink_eop, sink_sop);
    end

endmodule
