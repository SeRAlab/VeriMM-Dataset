`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg baud_rate;
    reg clk;
    reg [7:0] data_in;
    reg start_tx;
    wire tx_line;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .baud_rate(baud_rate),
        .clk(clk),
        .data_in(data_in),
        .start_tx(start_tx),
        .tx_line(tx_line)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start_tx = 0;
            data_in = 8'h00;
            baud_rate = 0;
            #20;
            @(posedge clk);
        end
        endtask
    task verify_uart_frame;

        input [7:0] expected_data;
        integer i;
        begin


            repeat (CLKS_PER_BIT / 2) @(posedge clk);
            $display("  Checking Start Bit...");
            #1;

            check_outputs(1'b0);


            for (i = 0; i < 8; i = i + 1) begin
                repeat (CLKS_PER_BIT) @(posedge clk);
                $display("  Checking Data Bit %0d...", i);
                #1;

                check_outputs(expected_data[i]);
            end


            repeat (CLKS_PER_BIT) @(posedge clk);
            $display("  Checking Stop Bit...");
            #1;

            check_outputs(1'b1);


            repeat (CLKS_PER_BIT / 2) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmitting 0x55", test_num);
            reset_dut();
            data_in = 8'h55;
            @(posedge clk);
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;
            verify_uart_frame(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmitting 0xAA", test_num);
            reset_dut();
            data_in = 8'hAA;
            @(posedge clk);
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;
            verify_uart_frame(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmitting 0x00", test_num);
            reset_dut();
            data_in = 8'h00;
            @(posedge clk);
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;
            verify_uart_frame(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmitting 0xFF", test_num);
            reset_dut();
            data_in = 8'hFF;
            @(posedge clk);
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;
            verify_uart_frame(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmitting 0x12", test_num);
            reset_dut();
            data_in = 8'h12;
            @(posedge clk);
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;
            verify_uart_frame(8'h12);
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
        input expected_tx_line;
        begin
            if (expected_tx_line === (expected_tx_line ^ tx_line ^ expected_tx_line)) begin
                $display("PASS");
                $display("  Outputs: tx_line=%b",
                         tx_line);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_line=%b",
                         expected_tx_line);
                $display("  Got:      tx_line=%b",
                         tx_line);
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
        $dumpvars(0,baud_rate, clk, data_in, start_tx, tx_line);
    end

endmodule
