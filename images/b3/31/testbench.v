`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg load;
    reg reset;
    reg shift;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .load(load),
        .reset(reset),
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
            @(negedge clk);
            reset = 1;
            load = 0;
            shift = 0;
            data = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Verification");
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load 16'hABCD");
            reset_dut();
            @(negedge clk);
            data = 16'hABCD;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load and Shift Left Once");
            reset_dut();
            @(negedge clk);
            data = 16'h8001;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiple Shifts");
            reset_dut();
            @(negedge clk);
            data = 16'hF000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            repeat (4) @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset Priority");
            reset_dut();
            @(negedge clk);
            data = 16'hFFFF;
            load = 1;
            shift = 1;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            load = 0;
            shift = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Load Priority over Shift");
            reset_dut();
            @(negedge clk);
            data = 16'h5555;
            load = 1;
            shift = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 0;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Bit Traversal (LSB to MSB)");
            reset_dut();
            @(negedge clk);
            data = 16'h0001;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            repeat (15) @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(16'h8000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: No Change when Idle");
            reset_dut();
            @(negedge clk);
            data = 16'h1234;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
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
        input [15:0] expected_out;
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
        $dumpvars(0,clk, data, load, reset, shift, out);
    end

endmodule
