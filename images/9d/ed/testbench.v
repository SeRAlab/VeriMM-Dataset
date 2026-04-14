`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] D_in;
    reg clear;
    reg clock;
    reg enable;
    reg resetn;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D_in(D_in),
        .clear(clear),
        .clock(clock),
        .enable(enable),
        .resetn(resetn),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            clear = 0;
            enable = 0;
            D_in = 0;
            #20;
            resetn = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase 002: Data Propagation");
            reset_dut();

            @(posedge clock);
            D_in = 32'hA5A5A5A5;
            enable = 1;


            repeat(4) @(posedge clock);

            #1;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase 003: Enable Control");
            reset_dut();


            @(posedge clock);
            D_in = 32'h12345678;
            enable = 1;
            repeat(2) @(posedge clock);


            enable = 0;
            D_in = 32'hFFFFFFFF;
            repeat(4) @(posedge clock);

            #1;


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase 004: Synchronous Clear");
            reset_dut();


            enable = 1;
            D_in = 32'hFFFFFFFF;
            repeat(4) @(posedge clock);


            #1;
            if (Q !== 32'hFFFFFFFF) $display("Setup for Clear failed");


            @(posedge clock);
            clear = 1;
            @(posedge clock);
            clear = 0;

            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        reg [31:0] val1, val2, val3, val4;
        begin
            test_num = 5;
            $display("\nTestcase 005: Continuous Stream");
            reset_dut();

            val1 = 32'h11111111;
            val2 = 32'h22222222;
            val3 = 32'h33333333;
            val4 = 32'h44444444;

            enable = 1;

            @(posedge clock); D_in = val1;
            @(posedge clock); D_in = val2;
            @(posedge clock); D_in = val3;
            @(posedge clock); D_in = val4;


            #1;
            #1;

            check_outputs(val1);
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
        input [31:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D_in, clear, clock, enable, resetn, Q);
    end

endmodule
