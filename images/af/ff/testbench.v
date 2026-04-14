`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg reset;
    reg [1:0] select;
    wire [1:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .select(select),
        .LED(LED)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 0;
            select = 2'b10;
            #12;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Reset for ff1 (Select 00)");
            reset_dut();
            select = 2'b00;
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking Reset for ff2 (Select 01)");
            reset_dut();
            select = 2'b01;
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify Rising Edge Capture (Select 00)");
            reset_dut();
            d = 1;
            @(posedge clk);
            #2 select = 2'b00;
            #2 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify Falling Edge Capture (Select 01)");
            reset_dut();
            d = 1;
            @(negedge clk);
            #2 select = 2'b01;
            #2 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verify Constant LOW (Select 10)");
            reset_dut();

            d = 1;
            @(posedge clk);
            select = 2'b10;
            #2 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify Constant HIGH (Select 11)");
            reset_dut();
            select = 2'b11;
            #2 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Verify ff1 ignores falling edge");
            reset_dut();
            d = 1;
            @(posedge clk);
            #2 d = 0;
            @(negedge clk);
            #2 select = 2'b00;
            #2 #1;
 check_outputs(2'b01);
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
        input [1:0] expected_LED;
        begin
            if (expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: LED=%h",
                         LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h",
                         expected_LED);
                $display("  Got:      LED=%h",
                         LED);
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
        $dumpvars(0,clk, d, reset, select, LED);
    end

endmodule
