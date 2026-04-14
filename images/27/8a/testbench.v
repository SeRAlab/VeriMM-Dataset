`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg transmit;
    wire busy;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .transmit(transmit),
        .busy(busy),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            transmit = 0;
            data_in = 8'h00;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task send_and_wait;

        input [7:0] data;
        begin
            data_in = data;
            @(posedge clk);
            transmit = 1;
            @(posedge clk);
            transmit = 0;


            wait(busy == 1);

            wait(busy == 0);


            repeat(10) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            $display("\nRunning Testcase 001: Data 0x55");
            reset_dut();
            send_and_wait(8'h55);

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Data 0xAA");
            reset_dut();
            send_and_wait(8'hAA);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Data 0x00");
            reset_dut();
            send_and_wait(8'h00);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Data 0xFF");
            reset_dut();
            send_and_wait(8'hFF);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Data 0xA3");
            reset_dut();
            send_and_wait(8'hA3);
            #1;

            check_outputs(0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_transmitter Testbench");
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
        input expected_busy;
        input expected_tx;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, tx=%b",
                         busy, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, tx=%b",
                         expected_busy, expected_tx);
                $display("  Got:      busy=%b, tx=%b",
                         busy, tx);
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
        $dumpvars(0,clk, data_in, reset, transmit, busy, tx);
    end

endmodule
