`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg capture_en;
    reg [3:0] capture_in;
    reg clk;
    reg reset;
    reg shift_en;
    reg [3:0] shift_in;
    wire [3:0] capture_out;
    wire [3:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .capture_en(capture_en),
        .capture_in(capture_in),
        .clk(clk),
        .reset(reset),
        .shift_en(shift_en),
        .shift_in(shift_in),
        .capture_out(capture_out),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            capture_en = 0;
            capture_in = 4'b0;
            shift_en = 0;
            shift_in = 4'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Capture Operation", test_num);
            reset_dut();
            @(negedge clk);
            capture_en = 1;
            capture_in = 4'hA;
            @(posedge clk);
            #2;
            capture_en = 0;

            #1;


            check_outputs(4'hA, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Shift Operation", test_num);
            reset_dut();
            @(negedge clk);
            shift_en = 1;
            shift_in = 4'b0001;
            @(posedge clk);
            #2;
            shift_en = 0;

            #1;


            check_outputs(4'h0, 4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-cycle Shift (Full 4-bit load)", test_num);
            reset_dut();

            @(negedge clk); shift_en = 1; shift_in = 4'b0001;
            @(posedge clk); #2;
            @(negedge clk); shift_en = 1; shift_in = 4'b0000;
            @(posedge clk); #2;
            @(negedge clk); shift_en = 1; shift_in = 4'b0001;
            @(posedge clk); #2;
            @(negedge clk); shift_en = 1; shift_in = 4'b0001;
            @(posedge clk); #2;
            shift_en = 0;
            #1;

            check_outputs(4'h0, 4'b1011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Shift and Capture", test_num);
            reset_dut();
            @(negedge clk);
            shift_en = 1;
            shift_in = 4'b0001;
            capture_en = 1;
            capture_in = 4'hF;
            @(posedge clk);
            #2;
            shift_en = 0;
            capture_en = 0;
            #1;

            check_outputs(4'hF, 4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Enable Signals (Hold State)", test_num);
            reset_dut();

            @(negedge clk);
            shift_en = 1; shift_in = 4'b0001;
            capture_en = 1; capture_in = 4'h5;
            @(posedge clk); #2;

            @(negedge clk);
            shift_en = 0;
            capture_en = 0;
            shift_in = 4'b1111;
            capture_in = 4'hE;
            @(posedge clk); #2;

            #1;


            check_outputs(4'h5, 4'h1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Capture and Shifting Out", test_num);
            reset_dut();

            @(negedge clk); shift_en = 1; shift_in = 4'b0001;
            capture_en = 1; capture_in = 4'h1;
            @(posedge clk); #2;

            @(negedge clk); shift_en = 1; shift_in = 4'b0001;
            capture_en = 1; capture_in = 4'hF;
            @(posedge clk); #2;

            #1;


            check_outputs(4'hF, 4'b0011);
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
        input [3:0] expected_capture_out;
        input [3:0] expected_shift_out;
        begin
            if (expected_capture_out === (expected_capture_out ^ capture_out ^ expected_capture_out) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: capture_out=%h, shift_out=%h",
                         capture_out, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: capture_out=%h, shift_out=%h",
                         expected_capture_out, expected_shift_out);
                $display("  Got:      capture_out=%h, shift_out=%h",
                         capture_out, shift_out);
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
        $dumpvars(0,capture_en, capture_in, clk, reset, shift_en, shift_in, capture_out, shift_out);
    end

endmodule
