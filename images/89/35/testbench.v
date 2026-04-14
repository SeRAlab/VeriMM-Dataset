`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg load;
    reg reset;
    reg shift;
    wire [3:0] data_out;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .shift(shift),
        .data_out(data_out),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        load = 0;
        forever #5 load = ~load;
    end

        task reset_dut;

        begin
            reset = 1;
            shift = 0;
            data_in = 4'b0000;
            @(negedge load);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying synchronous reset to zero...", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Loading data 4'b1011 (Overflow expected)...", test_num);
            reset_dut();
            data_in = 4'b1011;
            shift = 0;
            @(negedge load);
            #1;

            check_outputs(4'b1011, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 4'b0101 -> 4'b1010...", test_num);
            reset_dut();
            data_in = 4'b0101;
            shift = 0;
            @(negedge load);
            shift = 1;
            @(negedge load);
            #1;

            check_outputs(4'b1010, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 4'b1010 -> 4'b0100...", test_num);
            reset_dut();
            data_in = 4'b1010;
            shift = 0;
            @(negedge load);
            shift = 1;
            @(negedge load);
            #1;

            check_outputs(4'b0100, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 4'b0111 three times...", test_num);
            reset_dut();
            data_in = 4'b0111;
            shift = 0;
            @(negedge load);
            shift = 1;
            @(negedge load);
            @(negedge load);
            @(negedge load);
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset priority over Shift operation...", test_num);
            reset_dut();
            data_in = 4'b1111;
            shift = 0;
            @(negedge load);
            reset = 1;
            shift = 1;
            @(negedge load);
            #1;

            check_outputs(4'b0000, 1'b0);
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
        input expected_overflow;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, overflow=%b",
                         data_out, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, overflow=%b",
                         expected_data_out, expected_overflow);
                $display("  Got:      data_out=%h, overflow=%b",
                         data_out, overflow);
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
        $dumpvars(0,data_in, load, reset, shift, data_out, overflow);
    end

endmodule
