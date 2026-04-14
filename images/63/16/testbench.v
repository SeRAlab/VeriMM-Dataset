`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] modulo;
    wire [9:0] count;
    wire oClk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .modulo(modulo),
        .count(count),
        .oClk(oClk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            modulo = 10'd1;

            repeat(2) @(posedge clk);
            #1;
            if (count !== 10'd0) begin
                @(posedge clk);
                #1;
            end
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase 001: Modulo 10, count reaching modulo");
            reset_dut();
            modulo = 10'd10;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(10'd10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase 002: Modulo 10, wrap around to 0");
            reset_dut();
            modulo = 10'd10;
            repeat(11) @(posedge clk);
            #1 #1;
 check_outputs(10'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase 003: Modulo 5, count below modulo");
            reset_dut();
            modulo = 10'd5;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(10'd3, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase 004: Modulo 5, count exactly at modulo");
            reset_dut();
            modulo = 10'd5;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(10'd5, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase 005: Modulo 1");
            reset_dut();
            modulo = 10'd1;
            repeat(1) @(posedge clk);
            #1 #1;
 check_outputs(10'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase 006: Max Modulo 1023");
            reset_dut();
            modulo = 10'd1023;
            repeat(1023) @(posedge clk);
            #1 #1;
 check_outputs(10'd1023, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase 007: Safe recovery (Count > Modulo)");
            reset_dut();
            modulo = 10'd20;
            repeat(15) @(posedge clk);
            #1 modulo = 10'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(10'd0, 1'b0);
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
        input [9:0] expected_count;
        input expected_oClk;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_oClk === (expected_oClk ^ oClk ^ expected_oClk)) begin
                $display("PASS");
                $display("  Outputs: count=%h, oClk=%b",
                         count, oClk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, oClk=%b",
                         expected_count, expected_oClk);
                $display("  Got:      count=%h, oClk=%b",
                         count, oClk);
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
        $dumpvars(0,clk, modulo, count, oClk);
    end

endmodule
