`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg load;
    reg shift;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .load(load),
        .shift(shift),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        load <= 1;
        in <= 8'h00;
        shift <= 0;
        @(posedge clk);
        load <= 0;
        in <= 8'h00;
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Load value 8'hA5");
        @(posedge clk);
        load <= 1;
        in <= 8'hA5;
        @(posedge clk);
        load <= 0;
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Load 8'h02 and shift right once (Result should be 8'h01)");
        @(posedge clk);
        load <= 1;
        in <= 8'h02;
        @(posedge clk);
        load <= 0;
        shift <= 1;
        @(posedge clk);
        shift <= 0;
        #1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Load 8'h80 and shift right once (Result should be 8'h40, checking MSB 0)");
        @(posedge clk);
        load <= 1;
        in <= 8'h80;
        @(posedge clk);
        load <= 0;
        shift <= 1;
        @(posedge clk);
        shift <= 0;
        #1;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Load 8'hF0 and shift right 4 times (Result should be 8'h0F)");
        @(posedge clk);
        load <= 1;
        in <= 8'hF0;
        @(posedge clk);
        load <= 0;
        shift <= 1;
        repeat(4) @(posedge clk);
        shift <= 0;
        #1;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Load 8'h55 and hold for 2 cycles");
        @(posedge clk);
        load <= 1;
        in <= 8'h55;
        @(posedge clk);
        load <= 0;
        shift <= 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase 006: Assert both Load and Shift (Testing priority)");
        @(posedge clk);
        load <= 1;
        shift <= 1;
        in <= 8'hFF;
        @(posedge clk);
        load <= 0;
        shift <= 0;
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        $display("Testcase 007: Shift 8 times to clear register to 0");
        @(posedge clk);
        load <= 1;
        in <= 8'hFF;
        @(posedge clk);
        load <= 0;
        shift <= 1;
        repeat(8) @(posedge clk);
        shift <= 0;
        #1;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, load, shift, out);
    end

endmodule
