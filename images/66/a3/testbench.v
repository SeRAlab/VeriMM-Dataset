`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg gen;
    reg resetq;
    wire [31:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .gen(gen),
        .resetq(resetq),
        .r(r)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetq = 1'b0;
            gen = 1'b0;
            repeat(2) @(posedge clk);
            #1 resetq = 1'b1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset Check");
            reset_dut();
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single Step update");
            reset_dut();
            gen = 1'b1;
            @(posedge clk);
            #1 gen = 1'b0;
            #1;

            check_outputs(32'h00042021);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Two-Step update");
            reset_dut();
            gen = 1'b1;
            repeat(2) @(posedge clk);
            #1 gen = 1'b0;
            #1;

            check_outputs(32'h04008421);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Three-Step update");
            reset_dut();
            gen = 1'b1;
            repeat(3) @(posedge clk);
            #1 gen = 1'b0;
            #1;

            check_outputs(32'h84116203);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Stall Check (gen=0)");
            reset_dut();
            gen = 1'b1;
            @(posedge clk);
            #1 gen = 1'b0;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(32'h00042021);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Reset mid-sequence");
            reset_dut();
            gen = 1'b1;
            repeat(5) @(posedge clk);
            #1 resetq = 1'b0;
            @(posedge clk);
            #1 resetq = 1'b1;
            #1;

            check_outputs(32'h00000001);
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
        input [31:0] expected_r;
        begin
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%h",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h",
                         expected_r);
                $display("  Got:      r=%h",
                         r);
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
        $dumpvars(0,clk, gen, resetq, r);
    end

endmodule
