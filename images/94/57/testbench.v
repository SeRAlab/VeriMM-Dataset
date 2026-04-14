`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] DATA;
    reg LOAD;
    reg RESET;
    reg clk;
    wire [1:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA(DATA),
        .LOAD(LOAD),
        .RESET(RESET),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        RESET = 1;
        LOAD = 0;
        DATA = 2'b00;
        @(negedge clk);
        RESET = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Synchronous Reset...");
        reset_dut();

        #1;


        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Increment (0 to 1)...");
        reset_dut();
        @(negedge clk);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Load DATA=2'b10...");
        reset_dut();
        @(negedge clk);
        LOAD = 1;
        DATA = 2'b10;
        @(negedge clk);
        LOAD = 0;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Load then Increment...");
        reset_dut();
        @(negedge clk);
        LOAD = 1;
        DATA = 2'b01;
        @(negedge clk);
        LOAD = 0;
        @(negedge clk);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Rollover (3 to 0)...");
        reset_dut();
        LOAD = 1;
        DATA = 2'b11;
        @(negedge clk);
        LOAD = 0;
        @(negedge clk);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Reset priority over Load...");
        reset_dut();
        @(negedge clk);
        RESET = 1;
        LOAD = 1;
        DATA = 2'b11;
        @(negedge clk);
        RESET = 0;
        LOAD = 0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Full cycle (0->1->2->3->0)...");
        reset_dut();
        repeat(4) @(negedge clk);
        #1;

        check_outputs(2'b00);
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
        input [1:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,DATA, LOAD, RESET, clk, Q);
    end

endmodule
