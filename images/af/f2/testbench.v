`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg reset;
    reg serial_in;
    reg shift;
    wire [3:0] final_output;
    wire [2:0] index;
    wire out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .serial_in(serial_in),
        .shift(shift),
        .final_output(final_output),
        .index(index),
        .out(out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            serial_in = 0;
            shift = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Shift Register Check", test_num);
            reset_dut();


            serial_in = 1; shift = 1; @(posedge clk); #1;

            serial_in = 0; shift = 1; @(posedge clk); #1;

            serial_in = 1; shift = 1; @(posedge clk); #1;

            serial_in = 1; shift = 1; @(posedge clk); #1;

            shift = 0;
            #1;

            check_outputs(4'b1011, 3'd0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Encoder MSB (Bit 7)", test_num);
            reset_dut();
            in = 8'b1000_0000;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0000, 3'd7, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Encoder LSB (Bit 0)", test_num);
            reset_dut();
            in = 8'b0000_0001;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0000, 3'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Bits Priority Check", test_num);
            reset_dut();
            in = 8'b0010_1101;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0000, 3'd5, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No Bits Active (Valid=0)", test_num);
            reset_dut();
            in = 8'b0000_0000;
            @(posedge clk); #1;

            #1;


            check_outputs(4'b0000, 3'd0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Shift and Priority", test_num);
            reset_dut();

            in = 8'b0100_0000;
            serial_in = 1; shift = 1; @(posedge clk); #1;
            serial_in = 0; shift = 1; @(posedge clk); #1;
            serial_in = 1; shift = 1; @(posedge clk); #1;
            serial_in = 0; shift = 1; @(posedge clk); #1;

            shift = 0;
            #1;

            check_outputs(4'b1010, 3'd6, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Register Overflow (5 bits)", test_num);
            reset_dut();

            shift = 1;
            serial_in = 1; @(posedge clk); #1;
            serial_in = 1; @(posedge clk); #1;
            serial_in = 1; @(posedge clk); #1;
            serial_in = 1; @(posedge clk); #1;
            serial_in = 0; @(posedge clk); #1;

            shift = 0;
            #1;

            check_outputs(4'b1110, 3'd0, 1'b0, 1'b0);
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
        input [3:0] expected_final_output;
        input [2:0] expected_index;
        input expected_out;
        input expected_valid;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_index === (expected_index ^ index ^ expected_index) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, index=%h, out=%b, valid=%b",
                         final_output, index, out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, index=%h, out=%b, valid=%b",
                         expected_final_output, expected_index, expected_out, expected_valid);
                $display("  Got:      final_output=%h, index=%h, out=%b, valid=%b",
                         final_output, index, out, valid);
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
        $dumpvars(0,clk, in, reset, serial_in, shift, final_output, index, out, valid);
    end

endmodule
