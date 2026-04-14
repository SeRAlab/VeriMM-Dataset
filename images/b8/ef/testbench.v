`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in1;
    reg in2;
    reg serial_in;
    wire out;
    wire [2:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .serial_in(serial_in),
        .out(out),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        serial_in = 0;
        in1 = 0;
        in2 = 0;
        repeat(4) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;

        serial_in = 0; in1 = 1; in2 = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 3'b111);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;

        serial_in = 1; in1 = 0; in2 = 1;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 3'b111);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;

        serial_in = 0; in1 = 1; in2 = 0;
        @(posedge clk); #1;

        serial_in = 1; in1 = 1; in2 = 0;
        @(posedge clk); #1;

        serial_in = 0; in1 = 1; in2 = 0;
        @(posedge clk); #1;

        #1;


        check_outputs(1'b1, 3'b101);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;

        serial_in = 0; in1 = 0; in2 = 1;
        @(posedge clk); #1;

        serial_in = 1; in1 = 0; in2 = 1;
        @(posedge clk); #1;

        serial_in = 0; in1 = 0; in2 = 1;
        @(posedge clk); #1;

        #1;


        check_outputs(1'b0, 3'b010);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;

        serial_in = 0; in1 = 1; @(posedge clk); #1;
        serial_in = 0; in1 = 0; @(posedge clk); #1;
        serial_in = 0; in1 = 0; @(posedge clk); #1;

        #1;


        check_outputs(1'b1, 3'b100);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;

        serial_in = 0; in1 = 0; @(posedge clk); #1;
        serial_in = 0; in1 = 0; @(posedge clk); #1;
        serial_in = 0; in1 = 1; @(posedge clk); #1;

        #1;


        check_outputs(1'b1, 3'b001);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;

        serial_in = 0; in1 = 1; @(posedge clk); #1;
        serial_in = 0; in1 = 0; @(posedge clk); #1;
        serial_in = 0; in1 = 1; @(posedge clk); #1;
        serial_in = 0; in1 = 0; @(posedge clk); #1;

        #1;


        check_outputs(1'b0, 3'b010);
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
        input expected_out;
        input [2:0] expected_shift_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b, shift_out=%h",
                         out, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, shift_out=%h",
                         expected_out, expected_shift_out);
                $display("  Got:      out=%b, shift_out=%h",
                         out, shift_out);
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
        $dumpvars(0,clk, in1, in2, serial_in, out, shift_out);
    end

endmodule
