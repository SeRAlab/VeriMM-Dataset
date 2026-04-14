`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg send;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data(data),
        .send(send),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        send = 0;
        data = 8'h00;
        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        data = 8'hFF;
        @(posedge clk);
        send = 1;
        @(posedge clk);
        send = 0;
        #(BIT_TIME * 0.5);
        $display("Testcase 001: Checking Start Bit (Expected 0)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        data = 8'h55;
        @(posedge clk);
        send = 1;
        @(posedge clk);
        send = 0;
        #(BIT_TIME * 1.5);
        $display("Testcase 002: Checking Data Bit 0 of 0x55 (Expected 1)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        data = 8'h55;
        @(posedge clk);
        send = 1;
        @(posedge clk);
        send = 0;
        #(BIT_TIME * 2.5);
        $display("Testcase 003: Checking Data Bit 1 of 0x55 (Expected 0)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        data = 8'hAA;
        @(posedge clk);
        send = 1;
        @(posedge clk);
        send = 0;
        #(BIT_TIME * 1.5);
        $display("Testcase 004: Checking Data Bit 0 of 0xAA (Expected 0)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        data = 8'h00;
        @(posedge clk);
        send = 1;
        @(posedge clk);
        send = 0;
        #(BIT_TIME * 9.5);
        $display("Testcase 005: Checking Stop Bit (Expected 1)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        data = 8'h80;
        @(posedge clk);
        send = 1;
        @(posedge clk);
        send = 0;
        #(BIT_TIME * 8.5);
        $display("Testcase 006: Checking Data Bit 7 of 0x80 (Expected 1)");
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
        $display("uart_transmitter Testbench");
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
        input expected_tx;
        begin
            if (expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: tx=%b",
                         tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx=%b",
                         expected_tx);
                $display("  Got:      tx=%b",
                         tx);
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
        $dumpvars(0,clk, data, send, tx);
    end

endmodule
