`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] new_nonces;
    reg serial_busy;
    reg [63:0] slave_nonces;
    reg uart_clk;
    wire [31:0] golden_nonce;
    wire serial_send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .new_nonces(new_nonces),
        .serial_busy(serial_busy),
        .slave_nonces(slave_nonces),
        .uart_clk(uart_clk),
        .golden_nonce(golden_nonce),
        .serial_send(serial_send)
    );

    // Clock generation (10ns period)
    initial begin
        uart_clk = 0;
        forever #5 uart_clk = ~uart_clk;
    end

        task reset_dut;

        begin
            new_nonces = 2'b00;
            serial_busy = 1'b1;
            slave_nonces = 64'h0;
            repeat(2) @(posedge uart_clk);
            serial_busy = 1'b0;
            @(posedge uart_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Slave 0 basic send", test_num);
            reset_dut();
            slave_nonces = 64'hAAAA_AAAA_BBBB_BBBB;
            new_nonces = 2'b01;
            @(posedge uart_clk);
            #2;
            #1;

            check_outputs(32'hBBBB_BBBB, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Slave 1 basic send", test_num);
            reset_dut();
            slave_nonces = 64'h1234_5678_9ABC_DEF0;
            new_nonces = 2'b10;
            @(posedge uart_clk);
            #2;
            #1;

            check_outputs(32'h1234_5678, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Serial busy blocking", test_num);
            reset_dut();
            serial_busy = 1'b1;
            slave_nonces = 64'hFFFF_FFFF_EEEE_EEEE;
            new_nonces = 2'b01;
            repeat(3) @(posedge uart_clk);
            #2;

            #1;


            check_outputs(golden_nonce, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Sequential multi-slave request", test_num);
            reset_dut();
            slave_nonces = 64'h1111_2222_3333_4444;
            new_nonces = 2'b11;
            @(posedge uart_clk);
            #2;

            #1;


            check_outputs(32'h3333_4444, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Idle state (no requests)", test_num);
            reset_dut();
            new_nonces = 2'b00;
            repeat(2) @(posedge uart_clk);
            #2;
            #1;

            check_outputs(golden_nonce, 1'b0);
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
        input [31:0] expected_golden_nonce;
        input expected_serial_send;
        begin
            if (expected_golden_nonce === (expected_golden_nonce ^ golden_nonce ^ expected_golden_nonce) &&
                expected_serial_send === (expected_serial_send ^ serial_send ^ expected_serial_send)) begin
                $display("PASS");
                $display("  Outputs: golden_nonce=%h, serial_send=%b",
                         golden_nonce, serial_send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: golden_nonce=%h, serial_send=%b",
                         expected_golden_nonce, expected_serial_send);
                $display("  Got:      golden_nonce=%h, serial_send=%b",
                         golden_nonce, serial_send);
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
        $dumpvars(0,new_nonces, serial_busy, slave_nonces, uart_clk, golden_nonce, serial_send);
    end

endmodule
