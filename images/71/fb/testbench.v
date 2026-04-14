`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [255:0] rx_a;
    reg [255:0] rx_b;
    wire tx_done;
    wire [511:0] tx_r;

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
        .tx_done(tx_done),
        .tx_r(tx_r)
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
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task wait_until_done;

        begin
            @(posedge clk);
            while (!tx_done) @(posedge clk);
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Zero multiplication");
            reset_dut();
            rx_a = 256'd0;
            rx_b = 256'd0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 512'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Identity multiplication");
            reset_dut();
            rx_a = 256'hA5A5A5A5_5A5A5A5A_A5A5A5A5_5A5A5A5A_A5A5A5A5_5A5A5A5A_A5A5A5A5_5A5A5A5A;
            rx_b = 256'd1;
            wait_until_done();
            #1;

            check_outputs(1'b1, {256'd0, 256'hA5A5A5A5_5A5A5A5A_A5A5A5A5_5A5A5A5A_A5A5A5A5_5A5A5A5A_A5A5A5A5_5A5A5A5A});
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Small value multiplication");
            reset_dut();
            rx_a = 256'd12345;
            rx_b = 256'd67890;
            wait_until_done();
            #1;

            check_outputs(1'b1, 512'd838102050);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Power of 2 multiplication (Shift)");
            reset_dut();
            rx_a = (256'b1 << 128);
            rx_b = (256'b1 << 64);
            wait_until_done();

            #1;


            check_outputs(1'b1, (512'b1 << 192));
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Max 256-bit value * 2");
            reset_dut();
            rx_a = {256{1'b1}};
            rx_b = 256'd2;
            wait_until_done();

            #1;


            check_outputs(1'b1, (512'b1 << 257) - 512'd2);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Max 256-bit * Max 256-bit");
            reset_dut();
            rx_a = {256{1'b1}};
            rx_b = {256{1'b1}};
            wait_until_done();


            #1;



            check_outputs(1'b1, ({255{1'b1}}, 1'b0, {255{1'b0}}, 1'b1));
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
        input expected_tx_done;
        input [511:0] expected_tx_r;
        begin
            if (expected_tx_done === (expected_tx_done ^ tx_done ^ expected_tx_done) &&
                expected_tx_r === (expected_tx_r ^ tx_r ^ expected_tx_r)) begin
                $display("PASS");
                $display("  Outputs: tx_done=%b, tx_r=%h",
                         tx_done, tx_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_done=%b, tx_r=%h",
                         expected_tx_done, expected_tx_r);
                $display("  Got:      tx_done=%b, tx_r=%h",
                         tx_done, tx_r);
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
        $dumpvars(0,clk, reset, rx_a, rx_b, tx_done, tx_r);
    end

endmodule
