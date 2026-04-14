`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            data_in = 8'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task verify_transmission;

        input [7:0] expected_data;
        integer i;
        begin


            repeat (CLKS_PER_BIT / 2) @(posedge clk);
            $display("  Checking Start Bit...");
            #1;

            check_outputs(1'b0);


            for (i = 0; i < 8; i = i + 1) begin
                repeat (CLKS_PER_BIT) @(posedge clk);
                $display("  Checking Data Bit %0d (value: %b)...", i, expected_data[i]);
                #1;

                check_outputs(expected_data[i]);
            end


            repeat (CLKS_PER_BIT) @(posedge clk);
            $display("  Checking Stop Bit...");
            #1;

            check_outputs(1'b1);


            repeat (CLKS_PER_BIT) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTest Case %0d: Sending 0x55 (Alternating bits)", test_num);
            data_in = 8'h55;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            verify_transmission(8'h55);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTest Case %0d: Sending 0xAA (Alternating bits)", test_num);
            data_in = 8'hAA;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            verify_transmission(8'hAA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTest Case %0d: Sending 0x00", test_num);
            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            verify_transmission(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTest Case %0d: Sending 0xFF", test_num);
            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            verify_transmission(8'hFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTest Case %0d: Sending 0xC3", test_num);
            data_in = 8'hC3;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            verify_transmission(8'hC3);
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
        $dumpvars(0,clk, data_in, rst, start, tx);
    end

endmodule
