`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
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
        .rst(rst),
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
            rst = 1;
            tx_enable = 0;
            data_in = 8'h00;
            repeat(5) @(posedge clk);
            rst = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task run_uart_test;

        input [7:0] data_to_send;
        reg [9:0] expected_frame;
        reg success;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmitting Data 0x%h", test_num, data_to_send);
            reset_dut();

            data_in = data_to_send;
            expected_frame = {1'b1, data_to_send, 1'b0};


            @(posedge clk);
            tx_enable = 1;
            @(posedge clk);
            tx_enable = 0;

            success = 1;


            @(negedge tx_out);


            for (i = 0; i < 10; i = i + 1) begin
                repeat(5) @(posedge clk);
                if (tx_out !== expected_frame[i]) begin
                    $display("  Error at bit %0d: Expected %b, Got %b", i, expected_frame[i], tx_out);
                    success = 0;
                end
                repeat(5) @(posedge clk);
            end


            #1;



            check_outputs(success ? tx_out : ~tx_out);
        end
        endtask

    task testcase001;

        begin
            run_uart_test(8'h55);
        end
        endtask

    task testcase002;

        begin
            run_uart_test(8'hAA);
        end
        endtask

    task testcase003;

        begin
            run_uart_test(8'h00);
        end
        endtask

    task testcase004;

        begin
            run_uart_test(8'hFF);
        end
        endtask

    task testcase005;

        begin
            run_uart_test(8'h3C);
        end
        endtask

    task testcase006;

        begin
            run_uart_test(8'hA5);
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
        $dumpvars(0,clk, data_in, rst, tx_enable, tx_out);
    end

endmodule
