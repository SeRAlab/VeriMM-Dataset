`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg shift_in;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift_in(shift_in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            data_in = 4'b0000;
            shift_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            load = 1;
            data_in = 4'b1011;
            @(posedge clk);
            #1;
            $display("Testcase 001: Parallel Load 1011");
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            load = 1;
            data_in = 4'b1111;
            @(posedge clk);
            #1;

            load = 0;
            shift_in = 0;
            @(posedge clk);
            #1;
            $display("Testcase 002: Load 1111, Shift In 0 (Expected 0111)");
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            load = 0;

            shift_in = 1; @(posedge clk); #1;

            shift_in = 0; @(posedge clk); #1;

            shift_in = 1; @(posedge clk); #1;
            $display("Testcase 003: Multi-shift (Expected 1010)");
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            load = 1;
            data_in = 4'b0101;
            shift_in = 1;
            @(posedge clk);
            #1;
            $display("Testcase 004: Priority Check (Load=1, Shift_in=1)");
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            load = 0;
            shift_in = 1;
            repeat(4) @(posedge clk);
            #1;
            $display("Testcase 005: Shift in 1s for 4 cycles");
            #1;

            check_outputs(4'b1111);
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data_in, load, shift_in, q);
    end

endmodule
