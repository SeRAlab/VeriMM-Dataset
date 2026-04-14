`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [255:0] rx_a;
    reg [255:0] rx_b;
    reg [255:0] rx_p;
    wire [255:0] tx_a;
    wire tx_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .rx_a(rx_a),
        .rx_b(rx_b),
        .rx_p(rx_p),
        .tx_a(tx_a),
        .tx_done(tx_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            rx_a = 0;
            rx_b = 0;
            rx_p = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task wait_for_done;

        begin

            while (!tx_done) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %0d: Simple Addition (a+b < p)", test_num);
            rx_a = 256'h1234;
            rx_b = 256'h5678;
            rx_p = 256'hFFFF;
            wait_for_done();
            #1;

            check_outputs(256'h68AC, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %0d: Addition with wrap-around (a+b >= p)", test_num);
            rx_a = 256'd80;
            rx_b = 256'd40;
            rx_p = 256'd100;
            wait_for_done();
            #1;

            check_outputs(256'd20, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %0d: Boundary - Max value", test_num);
            rx_a = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE;
            rx_b = 256'h0;
            rx_p = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            wait_for_done();
            #1;

            check_outputs(rx_a, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %0d: Boundary - Exact modulo", test_num);
            rx_a = 256'hA;
            rx_b = 256'h5;
            rx_p = 256'hF;
            wait_for_done();
            #1;

            check_outputs(256'h0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %0d: Large Prime Modulus", test_num);

            rx_p = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
            rx_a = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364140;
            rx_b = 256'h2;
            wait_for_done();
            #1;

            check_outputs(256'h1, 1'b1);
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
        input [255:0] expected_tx_a;
        input expected_tx_done;
        begin
            if (expected_tx_a === (expected_tx_a ^ tx_a ^ expected_tx_a) &&
                expected_tx_done === (expected_tx_done ^ tx_done ^ expected_tx_done)) begin
                $display("PASS");
                $display("  Outputs: tx_a=%h, tx_done=%b",
                         tx_a, tx_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_a=%h, tx_done=%b",
                         expected_tx_a, expected_tx_done);
                $display("  Got:      tx_a=%h, tx_done=%b",
                         tx_a, tx_done);
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
        $dumpvars(0,clk, reset, rx_a, rx_b, rx_p, tx_a, tx_done);
    end

endmodule
