`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [511:0] rx_a;
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
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            rx_a = 512'h0;
            #1;

            check_outputs(256'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            rx_a = 512'h1;
            #1;

            check_outputs(256'h1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            rx_a = {256'h0, P - 256'h1};
            #1;

            check_outputs(P - 256'h1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            rx_a = {256'h0, P};
            #1;

            check_outputs(256'h0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            rx_a = {256'h0, P} + 512'h1;
            #1;

            check_outputs(256'h1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            rx_a = 512'h1 << 256;
            #1;

            check_outputs(256'h1000003D1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            rx_a = {256'h0, P} << 1;
            #1;

            check_outputs(256'h0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            rx_a = ({256'h0, P} << 256) + {256'h0, P};
            #1;

            check_outputs(256'h0, 1'b1);
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
        testcase008();
        
        
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
        $dumpvars(0,clk, reset, rx_a, tx_a, tx_done);
    end

endmodule
