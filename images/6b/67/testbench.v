`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg ce;
    reg clk;
    reg [7:0] data;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .ce(ce),
        .clk(clk),
        .data(data),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            ce = 1;
            data = 8'h00;
            a = 2'b00;
            repeat (4) @(negedge clk);
            ce = 0;
        end
        endtask
    task shift_in;

        input [7:0] val;
        begin
            @(negedge clk);
            ce = 1;
            data = val;
            @(negedge clk);
            ce = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic shift to depth 4 (a=3)", test_num);
            reset_dut();
            shift_in(8'hA1);
            shift_in(8'hB2);
            shift_in(8'hC3);
            shift_in(8'hD4);
            a = 2'b11;
            #1;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Clock Enable check", test_num);
            reset_dut();
            shift_in(8'h11);

            @(negedge clk);
            ce = 0;
            data = 8'hFF;
            @(negedge clk);

            shift_in(8'h22);
            a = 2'b01;
            #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Address selection 0 (Depth 1)", test_num);
            reset_dut();
            shift_in(8'h55);
            shift_in(8'h66);
            a = 2'b00;
            #1;
            #1;

            check_outputs(8'h66);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Address selection 2 (Depth 3)", test_num);
            reset_dut();
            shift_in(8'h10);
            shift_in(8'h20);
            shift_in(8'h30);
            a = 2'b10;
            #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Address selection 1 (Depth 2)", test_num);
            reset_dut();
            shift_in(8'hAA);
            shift_in(8'hBB);
            shift_in(8'hCC);
            a = 2'b01;
            #1;
            #1;

            check_outputs(8'hBB);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,a, ce, clk, data, q);
    end

endmodule
