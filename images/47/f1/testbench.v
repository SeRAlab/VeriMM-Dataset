`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] PA;
    reg clk;
    reg rst_n;
    wire event_latch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PA(PA),
        .clk(clk),
        .rst_n(rst_n),
        .event_latch(event_latch)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        PA = 8'h00;
        #20;
        rst_n = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge clk);
        PA = 8'hFF;


        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        @(posedge clk);
        PA = 8'hAA;
        repeat(2) @(posedge clk);
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        PA = 8'hAA;
        repeat(5) @(posedge clk);
        @(posedge clk);
        PA = 8'h55;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        PA = 8'h00;
        repeat(2) @(posedge clk);
        PA = 8'hEE;
        @(posedge clk);
        PA = 8'hCC;
        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1);
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
        input expected_event_latch;
        begin
            if (expected_event_latch === (expected_event_latch ^ event_latch ^ expected_event_latch)) begin
                $display("PASS");
                $display("  Outputs: event_latch=%b",
                         event_latch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: event_latch=%b",
                         expected_event_latch);
                $display("  Got:      event_latch=%b",
                         event_latch);
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
        $dumpvars(0,PA, clk, rst_n, event_latch);
    end

endmodule
