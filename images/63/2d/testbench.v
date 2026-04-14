`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg xoff_rcvd;
    reg xon_rcvd;
    wire inhibit_tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .xoff_rcvd(xoff_rcvd),
        .xon_rcvd(xon_rcvd),
        .inhibit_tx(inhibit_tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            xoff_rcvd = 0;
            xon_rcvd = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset behavior", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: XOFF received", test_num);
            reset_dut();
            @(negedge clk);
            xoff_rcvd = 1;
            @(negedge clk);
            xoff_rcvd = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: XON received after XOFF", test_num);
            reset_dut();
            @(negedge clk);
            xoff_rcvd = 1;
            @(negedge clk);
            xoff_rcvd = 0;
            xon_rcvd = 1;
            @(negedge clk);
            xon_rcvd = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Persistence of Inhibit after XOFF", test_num);
            reset_dut();
            @(negedge clk);
            xoff_rcvd = 1;
            @(negedge clk);
            xoff_rcvd = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Simultaneous XON and XOFF", test_num);
            reset_dut();
            @(negedge clk);
            xoff_rcvd = 1;
            xon_rcvd = 1;
            @(negedge clk);
            xoff_rcvd = 0;
            xon_rcvd = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Consecutive XOFF signals", test_num);
            reset_dut();
            @(negedge clk);
            xoff_rcvd = 1;
            @(negedge clk);
            xoff_rcvd = 0;
            repeat(3) @(posedge clk);
            xoff_rcvd = 1;
            @(negedge clk);
            xoff_rcvd = 0;
            @(posedge clk);
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
        input expected_inhibit_tx;
        begin
            if (expected_inhibit_tx === (expected_inhibit_tx ^ inhibit_tx ^ expected_inhibit_tx)) begin
                $display("PASS");
                $display("  Outputs: inhibit_tx=%b",
                         inhibit_tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inhibit_tx=%b",
                         expected_inhibit_tx);
                $display("  Got:      inhibit_tx=%b",
                         inhibit_tx);
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
        $dumpvars(0,clk, rst, xoff_rcvd, xon_rcvd, inhibit_tx);
    end

endmodule
