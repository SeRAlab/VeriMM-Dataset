`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg shift;
    reg [7:0] shift_in;
    wire [7:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .shift(shift),
        .shift_in(shift_in),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            shift = 0;
            shift_in = 0;
            @(negedge clk);
            rst = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Shift in a single '1' bit", test_num);
            reset_dut();
            shift = 1;
            shift_in = 8'h01;
            @(negedge clk);
            shift = 0;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Shift in 8 bits (0xFF)", test_num);
            reset_dut();
            shift = 1;
            shift_in = 8'h01;
            repeat (8) @(negedge clk);
            shift = 0;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = 4;
            $display("Testcase %0d: Shift in alternating pattern 0xA5", test_num);
            reset_dut();
            pattern = 8'hA5;
            shift = 1;
            for (i = 7; i >= 0; i = i - 1) begin
                shift_in = {7'b0, pattern[i]};
                @(negedge clk);
            end
            shift = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify shift enable signal (Pause Shifting)", test_num);
            reset_dut();
            shift = 1;
            shift_in = 8'h01;
            @(negedge clk);
            @(negedge clk);
            shift = 0;
            repeat (3) @(negedge clk);

            #1;


            check_outputs(8'h03);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify MSB discard (Shift 9 times)", test_num);
            reset_dut();
            shift = 1;

            shift_in = 8'h01;
            repeat (9) @(negedge clk);
            shift = 0;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        integer i;
        reg [11:0] sequence;
        begin
            test_num = 7;
            $display("Testcase %0d: Complex 12-bit sequence shift", test_num);
            reset_dut();
            sequence = 12'b1101_0011_1010;
            shift = 1;
            for (i = 11; i >= 0; i = i - 1) begin
                shift_in = {7'b0, sequence[i]};
                @(negedge clk);
            end
            shift = 0;

            #1;


            check_outputs(8'h3A);
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
        input [7:0] expected_shift_out;
        begin
            if (expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: shift_out=%h",
                         shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_out=%h",
                         expected_shift_out);
                $display("  Got:      shift_out=%h",
                         shift_out);
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
        $dumpvars(0,clk, rst, shift, shift_in, shift_out);
    end

endmodule
