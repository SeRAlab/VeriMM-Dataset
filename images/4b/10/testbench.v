`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    reg select;
    wire done;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .select(select),
        .done(done),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        d = 8'h00;
        select = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        d = 8'hA5;
        select = 0;
        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        d = 8'h5A;
        select = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        select = 1;

        repeat(3) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, q);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        select = 1;

        repeat(10) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, q);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        d = 8'hFF;
        select = 1;
        repeat(5) @(posedge clk);
        #1;
        select = 0;
        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(done, 8'hFF);
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
        input expected_done;
        input [7:0] expected_q;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: done=%b, q=%h",
                         done, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, q=%h",
                         expected_done, expected_q);
                $display("  Got:      done=%b, q=%h",
                         done, q);
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
        $dumpvars(0,clk, d, reset, select, done, q);
    end

endmodule
