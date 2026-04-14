`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [3:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .c(c)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking output after reset...");
            reset_dut();

            #1;


            check_outputs(VAL0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking stability before counter threshold...");
            reset_dut();
            repeat(100) @(posedge clk);

            #1;


            check_outputs(VAL0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking transition from State 0 to State 1...");
            reset_dut();



            force dut.cnt = COUNTER_MAX;
            @(posedge clk);
            #2 release dut.cnt;


            #1;



            check_outputs(VAL1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Checking sequence repetition (State 4)...");
            reset_dut();


            for (i = 0; i < 4; i = i + 1) begin
                force dut.cnt = COUNTER_MAX;
                @(posedge clk);
                #2 release dut.cnt;
            end


            #1;



            check_outputs(VAL0);
        end
        endtask

    task testcase005;

        integer j;
        begin
            $display("Testcase 005: Checking full cycle of 8 states...");
            reset_dut();


            for (j = 0; j < 8; j = j + 1) begin
                force dut.cnt = COUNTER_MAX;
                @(posedge clk);
                #2 release dut.cnt;
            end


            #1;



            check_outputs(VAL0);
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
        input [3:0] expected_c;
        begin
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
        $dumpvars(0,clk, rst, c);
    end

endmodule
