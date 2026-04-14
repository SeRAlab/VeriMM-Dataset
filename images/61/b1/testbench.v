`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg shift_in;
    wire [3:0] data_out;
    wire shift_out;

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
        .data_out(data_out),
        .shift_out(shift_out)
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
            $display("Testcase 001: Synchronous Load");
            reset_dut();
            data_in = 4'b1011;
            load = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1011, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Shift Right (shift_in=0)");
            reset_dut();

            data_in = 4'b1100;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift_in = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0110, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single Shift Right (shift_in=1)");
            reset_dut();

            data_in = 4'b0101;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1010, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multi-cycle Shifting");
            reset_dut();

            data_in = 4'b1111;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift_in = 0;
            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(4'b0001, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Alternating serial input");
            reset_dut();

            data_in = 4'b0000;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift_in = 1; @(posedge clk); #1;
            shift_in = 0; @(posedge clk); #1;
            shift_in = 1; @(posedge clk); #1;
            shift_in = 1; @(posedge clk); #1;

            #1;


            check_outputs(4'b1101, 1'b1);
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
        input [3:0] expected_data_out;
        input expected_shift_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, shift_out=%b",
                         data_out, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, shift_out=%b",
                         expected_data_out, expected_shift_out);
                $display("  Got:      data_out=%h, shift_out=%b",
                         data_out, shift_out);
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
        $dumpvars(0,clk, data_in, load, shift_in, data_out, shift_out);
    end

endmodule
