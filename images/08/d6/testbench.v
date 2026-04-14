`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg tx_enable;
    wire tx_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .tx_enable(tx_enable),
        .tx_out(tx_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        tx_enable = 0;
        data_in = 8'h00;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking Start Bit", test_num);
        reset_dut();
        data_in = 8'hFF;
        tx_enable = 1;
        @(posedge clk); #1;
        tx_enable = 0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking Data Bit 0 (LSB)", test_num);
        reset_dut();
        data_in = 8'h01;
        tx_enable = 1;
        @(posedge clk); #1;
        tx_enable = 0;
        @(posedge clk); #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking Data Bit 4", test_num);
        reset_dut();
        data_in = 8'h10;
        tx_enable = 1;
        @(posedge clk); #1;
        tx_enable = 0;
        repeat(5) @(posedge clk); #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking Data Bit 7 (MSB)", test_num);
        reset_dut();
        data_in = 8'h80;
        tx_enable = 1;
        @(posedge clk); #1;
        tx_enable = 0;
        repeat(8) @(posedge clk); #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking Stop Bit", test_num);
        reset_dut();
        data_in = 8'h00;
        tx_enable = 1;
        @(posedge clk); #1;
        tx_enable = 0;
        repeat(9) @(posedge clk); #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking IDLE state after transmission", test_num);
        reset_dut();
        data_in = 8'h55;
        tx_enable = 1;
        @(posedge clk); #1;
        tx_enable = 0;
        repeat(11) @(posedge clk); #1;

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
        input expected_tx_out;
        begin
            if (expected_tx_out === (expected_tx_out ^ tx_out ^ expected_tx_out)) begin
                $display("PASS");
                $display("  Outputs: tx_out=%b",
                         tx_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_out=%b",
                         expected_tx_out);
                $display("  Got:      tx_out=%b",
                         tx_out);
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
        $dumpvars(0,clk, data_in, tx_enable, tx_out);
    end

endmodule
