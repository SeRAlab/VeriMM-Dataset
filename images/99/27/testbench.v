`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg fph;
    reg [1:0] mode;
    reg reset;
    wire [13:0] phase;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fph(fph),
        .mode(mode),
        .reset(reset),
        .phase(phase)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            fph = 0;
            mode = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(14'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Mode 0 Accumulation (fph=1)", test_num);
            reset_dut();
            mode = 2'b00;
            fph = 1'b1;
            repeat(10) @(posedge clk);


            #1;



            check_outputs(14'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Mode 0 Accumulation Disabled (fph=0)", test_num);
            reset_dut();
            mode = 2'b00;
            fph = 1'b0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(14'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Mode Switching and Hold", test_num);
            reset_dut();
            mode = 2'b00; fph = 1'b1;
            repeat(5) @(posedge clk);
            mode = 2'b01;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(14'd5);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Accumulator Wrap-around", test_num);
            reset_dut();
            mode = 2'b00;
            fph = 1'b1;

            repeat(16384) @(posedge clk);
            #1;

            check_outputs(14'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Mid-operation Reset", test_num);
            reset_dut();
            mode = 2'b00; fph = 1'b1;
            repeat(100) @(posedge clk);
            reset_dut();
            #1;

            check_outputs(14'h0000);
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
        input [13:0] expected_phase;
        begin
            if (expected_phase === (expected_phase ^ phase ^ expected_phase)) begin
                $display("PASS");
                $display("  Outputs: phase=%h",
                         phase);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase=%h",
                         expected_phase);
                $display("  Got:      phase=%h",
                         phase);
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
        $dumpvars(0,clk, fph, mode, reset, phase);
    end

endmodule
