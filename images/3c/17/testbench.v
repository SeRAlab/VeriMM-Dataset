`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start_tx;
    wire tx;
    wire tx_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start_tx(start_tx),
        .tx(tx),
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
            start_tx = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Transmitting 0xA5 (10100101)", test_num);
            reset_dut();
            data_in = 8'hA5;
            start_tx = 1;
            @(posedge clk);
            #1 start_tx = 0;


            wait(tx_done == 1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transmitting 0x00", test_num);
            reset_dut();
            data_in = 8'h00;
            start_tx = 1;
            @(posedge clk);
            #1 start_tx = 0;

            wait(tx_done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transmitting 0xFF", test_num);
            reset_dut();
            data_in = 8'hFF;
            start_tx = 1;
            @(posedge clk);
            #1 start_tx = 0;

            wait(tx_done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Transmitting 0x55 (01010101)", test_num);
            reset_dut();
            data_in = 8'h55;
            start_tx = 1;
            @(posedge clk);
            #1 start_tx = 0;

            wait(tx_done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify post-reset idle state", test_num);
            reset_dut();

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
        input expected_tx;
        input expected_tx_done;
        begin
            if (expected_tx === (expected_tx ^ tx ^ expected_tx) &&
                expected_tx_done === (expected_tx_done ^ tx_done ^ expected_tx_done)) begin
                $display("PASS");
                $display("  Outputs: tx=%b, tx_done=%b",
                         tx, tx_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx=%b, tx_done=%b",
                         expected_tx, expected_tx_done);
                $display("  Got:      tx=%b, tx_done=%b",
                         tx, tx_done);
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
        $dumpvars(0,clk, data_in, reset, start_tx, tx, tx_done);
    end

endmodule
