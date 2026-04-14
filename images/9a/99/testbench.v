`timescale 1ns/1ps

module uart_tx_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] tx_data;
    reg tx_start;
    wire tx;
    wire tx_busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_tx dut (
        .clk(clk),
        .reset(reset),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            tx_start = 0;
            tx_data = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Transmitting 0x55...", test_num);
            reset_dut();
            tx_data = 8'h55;
            tx_start = 1;
            @(posedge clk);
            tx_start = 0;


            wait(tx_busy == 1);
            wait(tx_busy == 0);


            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Transmitting 0xAA...", test_num);
            reset_dut();
            tx_data = 8'hAA;
            tx_start = 1;
            @(posedge clk);
            tx_start = 0;

            wait(tx_busy == 1);
            wait(tx_busy == 0);

            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Transmitting 0x00...", test_num);
            reset_dut();
            tx_data = 8'h00;
            tx_start = 1;
            @(posedge clk);
            tx_start = 0;

            wait(tx_busy == 1);
            wait(tx_busy == 0);

            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Transmitting 0xFF...", test_num);
            reset_dut();
            tx_data = 8'hFF;
            tx_start = 1;
            @(posedge clk);
            tx_start = 0;

            wait(tx_busy == 1);
            wait(tx_busy == 0);

            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Transmitting 0x12...", test_num);
            reset_dut();
            tx_data = 8'h12;
            tx_start = 1;
            @(posedge clk);
            tx_start = 0;

            wait(tx_busy == 1);
            wait(tx_busy == 0);

            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_tx Testbench");
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
        input expected_tx;
        input expected_tx_busy;
        begin
            if (expected_tx === (expected_tx ^ tx ^ expected_tx) &&
                expected_tx_busy === (expected_tx_busy ^ tx_busy ^ expected_tx_busy)) begin
                $display("PASS");
                $display("  Outputs: tx=%b, tx_busy=%b",
                         tx, tx_busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx=%b, tx_busy=%b",
                         expected_tx, expected_tx_busy);
                $display("  Got:      tx=%b, tx_busy=%b",
                         tx, tx_busy);
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
        $dumpvars(0,clk, reset, tx_data, tx_start, tx, tx_busy);
    end

endmodule
