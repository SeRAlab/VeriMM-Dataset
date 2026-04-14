`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg [7:0] in;
    wire [1:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .in(in),
        .pos(pos)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in <= 8'b0;
            d <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            in <= 8'b00000000;
            repeat(2) @(posedge clk);
            $display("Testcase 001: No match");
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            in <= 8'b00000101;
            repeat(2) @(posedge clk);
            $display("Testcase 002: Match at pos 0");
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            in <= 8'b00001010;
            repeat(2) @(posedge clk);
            $display("Testcase 003: Match at pos 1");
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            in <= 8'b00010100;
            repeat(2) @(posedge clk);
            $display("Testcase 004: Match at pos 2");
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            in <= 8'b00101000;
            repeat(2) @(posedge clk);
            $display("Testcase 005: Match at pos 3");
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            in <= 8'b00101101;
            repeat(2) @(posedge clk);
            $display("Testcase 006: Multiple matches (0 and 3), Priority 0");
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            in <= 8'b00101010;
            repeat(2) @(posedge clk);
            $display("Testcase 007: Multiple matches (1 and 3), Priority 1");
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            in <= 8'b10100000;
            repeat(2) @(posedge clk);
            $display("Testcase 008: Match outside 2-bit range");

            #1;


            check_outputs(2'b00);
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
        testcase008();
        
        
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
        input [1:0] expected_pos;
        begin
            if (expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: pos=%h",
                         pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h",
                         expected_pos);
                $display("  Got:      pos=%h",
                         pos);
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
        $dumpvars(0,clk, d, in, pos);
    end

endmodule
