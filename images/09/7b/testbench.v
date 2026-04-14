`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start_transmit;
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
        .rst(rst),
        .start_transmit(start_transmit),
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
            rst = 1;
            data_in = 8'h00;
            start_transmit = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            $display("DUT Reset sequence completed.");
        end
        endtask
    task capture_byte;

        integer i;
        begin

            wait(tx == 0);

            @(posedge clk);

            for (i = 0; i < 8; i = i + 1) begin
                captured_data[i] = tx;
                @(posedge clk);
            end

            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sending 0x55 (Alternating bits)", test_num);
            reset_dut();

            data_in = 8'h55;
            start_transmit = 1;
            @(posedge clk);
            #1 start_transmit = 0;


            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sending 0xAA (Alternating bits)", test_num);
            reset_dut();

            data_in = 8'hAA;
            start_transmit = 1;
            @(posedge clk);
            #1 start_transmit = 0;

            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sending 0x00 (All Zeros)", test_num);
            reset_dut();

            data_in = 8'h00;
            start_transmit = 1;
            @(posedge clk);
            #1 start_transmit = 0;

            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sending 0xFF (All Ones)", test_num);
            reset_dut();

            data_in = 8'hFF;
            start_transmit = 1;
            @(posedge clk);
            #1 start_transmit = 0;

            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sending 0xC3 (11000011)", test_num);
            reset_dut();

            data_in = 8'hC3;
            start_transmit = 1;
            @(posedge clk);
            #1 start_transmit = 0;

            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
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
        $dumpvars(0,clk, data_in, rst, start_transmit, busy, tx);
    end

endmodule
