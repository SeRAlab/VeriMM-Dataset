`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ref_clk;
    reg txp;
    wire rxp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ref_clk(ref_clk),
        .txp(txp),
        .rxp(rxp)
    );

    // Clock generation (10ns period)
    initial begin
        ref_clk = 0;
        forever #5 ref_clk = ~ref_clk;
    end

        task reset_dut;

    begin
        txp = 1'b0;
        repeat(5) @(posedge ref_clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Starting Testcase %03d: Logic High Synchronization", test_num);
        reset_dut();
        @(posedge ref_clk);
        txp = 1'b1;
        repeat(3) @(posedge ref_clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Starting Testcase %03d: Logic Low Synchronization", test_num);
        reset_dut();

        @(posedge ref_clk);
        txp = 1'b1;
        repeat(3) @(posedge ref_clk);

        @(posedge ref_clk);
        txp = 1'b0;
        repeat(3) @(posedge ref_clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Starting Testcase %03d: Single Pulse Propagation", test_num);
        reset_dut();
        @(posedge ref_clk);
        txp = 1'b1;
        @(posedge ref_clk);
        txp = 1'b0;
        repeat(2) @(posedge ref_clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Starting Testcase %03d: Long Stability Check", test_num);
        reset_dut();
        @(posedge ref_clk);
        txp = 1'b1;
        repeat(10) @(posedge ref_clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Starting Testcase %03d: Rapid Toggle Sequence", test_num);
        reset_dut();
        @(posedge ref_clk);
        txp = 1'b1; @(posedge ref_clk);
        txp = 1'b0; @(posedge ref_clk);
        txp = 1'b1; @(posedge ref_clk);
        txp = 1'b0; @(posedge ref_clk);
        txp = 1'b1; @(posedge ref_clk);
        repeat(3) @(posedge ref_clk);
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
        input expected_rxp;
        begin
            if (expected_rxp === (expected_rxp ^ rxp ^ expected_rxp)) begin
                $display("PASS");
                $display("  Outputs: rxp=%b",
                         rxp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rxp=%b",
                         expected_rxp);
                $display("  Got:      rxp=%b",
                         rxp);
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
        $dumpvars(0,ref_clk, txp, rxp);
    end

endmodule
