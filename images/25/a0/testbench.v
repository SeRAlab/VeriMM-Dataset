`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg send;
    wire tx;
    wire tx_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .send(send),
        .tx(tx),
        .tx_complete(tx_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            send = 0;
            data_in = 8'h0;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Transmitting 0x55", test_num);
            reset_dut();
            data_in = 8'h55;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;



            wait(tx_complete == 1'b1);
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Transmitting 0xAA", test_num);
            reset_dut();
            data_in = 8'hAA;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;

            wait(tx_complete == 1'b1);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Transmitting 0x00", test_num);
            reset_dut();
            data_in = 8'h00;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;

            wait(tx_complete == 1'b1);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Transmitting 0xFF", test_num);
            reset_dut();
            data_in = 8'hFF;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;

            wait(tx_complete == 1'b1);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
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
        input expected_tx_complete;
        begin
            if (expected_tx === (expected_tx ^ tx ^ expected_tx) &&
                expected_tx_complete === (expected_tx_complete ^ tx_complete ^ expected_tx_complete)) begin
                $display("PASS");
                $display("  Outputs: tx=%b, tx_complete=%b",
                         tx, tx_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx=%b, tx_complete=%b",
                         expected_tx, expected_tx_complete);
                $display("  Got:      tx=%b, tx_complete=%b",
                         tx, tx_complete);
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
        $dumpvars(0,clk, data_in, reset, send, tx, tx_complete);
    end

endmodule
