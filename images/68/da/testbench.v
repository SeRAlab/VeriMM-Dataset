`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg clk;
    reg control;
    reg [2:0] parallel_load;
    reg shift;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .control(control),
        .parallel_load(parallel_load),
        .shift(shift),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A = 0;
        B = 0;
        control = 0;
        parallel_load = 3'b000;
        shift = 1;
        @(posedge clk);
        #1;
        shift = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;

        shift = 1; parallel_load = 3'b011; A = 0; B = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;

        shift = 1; parallel_load = 3'b011; A = 0; B = 0;
        @(posedge clk);
        #1;

        shift = 0; control = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;

        shift = 1; parallel_load = 3'b001; A = 0; B = 0;
        @(posedge clk);
        #1;

        shift = 0; control = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;

        shift = 1; parallel_load = 3'b010; A = 1; B = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0800);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;

        shift = 1; parallel_load = 3'b010; A = 1; B = 1;
        @(posedge clk); #1;
        shift = 0; control = 1;
        @(posedge clk); #1;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;

        shift = 1; parallel_load = 3'b011; A = 0; B = 1;
        @(posedge clk); #1;
        shift = 0; control = 0;
        @(posedge clk); #1;
        #1;

        check_outputs(16'h0020);
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
        input [15:0] expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
        $dumpvars(0,A, B, clk, control, parallel_load, shift, Y);
    end

endmodule
