`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] in1;
    reg [1:0] in2;
    reg select;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .select(select),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        in1 <= 2'b0;
        in2 <= 2'b0;
        select <= 2'b0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Select 0 (Decoder 1), in1=00", test_num);
        in1 <= 2'b00;
        select <= 2'b00;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Select 0 (Decoder 1), in1=11", test_num);
        in1 <= 2'b11;
        select <= 2'b00;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Select 1 (Decoder 2), in2=01", test_num);
        in2 <= 2'b01;
        select <= 2'b01;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Select 1 (Decoder 2), in2=10", test_num);
        in2 <= 2'b10;
        select <= 2'b01;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Select 2 (AND Logic), in1=11, in2=10", test_num);
        in1 <= 2'b11;
        in2 <= 2'b10;
        select <= 2'b10;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Select 2 (AND Logic), in1=01, in2=01", test_num);
        in1 <= 2'b01;
        in2 <= 2'b01;
        select <= 2'b10;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0001);
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
        $dumpvars(0,clk, in1, in2, select, out);
    end

endmodule
