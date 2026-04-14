`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg [3:0] in_0;
    reg [3:0] in_1;
    reg [3:0] in_2;
    reg [3:0] in_3;
    reg [1:0] sel;
    reg shift;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .in_0(in_0),
        .in_1(in_1),
        .in_2(in_2),
        .in_3(in_3),
        .sel(sel),
        .shift(shift),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        shift = 0;
        forever #5 shift = ~shift;
    end

        task reset_dut;

    begin
        data_in = 4'b0;
        in_0 = 4'b0; in_1 = 4'b0; in_2 = 4'b0; in_3 = 4'b0;
        sel = 2'b00;

        @(posedge shift);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Running Testcase %03d: Load in_0", test_num);
        in_0 = 4'b1010;
        sel = 2'b00;
        data_in = 4'b0000;
        @(posedge shift);
        #1;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Running Testcase %03d: Load in_1", test_num);
        in_1 = 4'b0101;
        sel = 2'b01;
        data_in = 4'b0001;
        @(posedge shift);
        #1;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Running Testcase %03d: Load in_2", test_num);
        in_2 = 4'b1111;
        sel = 2'b10;
        data_in = 4'b0001;
        @(posedge shift);
        #1;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Running Testcase %03d: Load in_3", test_num);
        in_3 = 4'b1100;
        sel = 2'b11;
        data_in = 4'b0000;
        @(posedge shift);
        #1;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Running Testcase %03d: Dynamic Shifting", test_num);


        data_in = 4'b0001; in_0 = 4'b0001; sel = 2'b00;
        @(posedge shift); #1;


        data_in = 4'b0001; in_0 = 4'b0011; sel = 2'b00;
        @(posedge shift); #1;


        data_in = 4'b0000; in_0 = 4'b0110; sel = 2'b00;
        @(posedge shift); #1;


        data_in = 4'b0001; in_0 = 4'b1101; sel = 2'b00;
        @(posedge shift); #1;

        #1;


        check_outputs(4'b1101);
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
        input [3:0] expected_out;
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
        $dumpvars(0,data_in, in_0, in_1, in_2, in_3, sel, shift, out);
    end

endmodule
