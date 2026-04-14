`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    reg send;
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
        .rst_n(rst_n),
        .send(send),
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
            rst_n = 0;
            send = 0;
            data_in = 8'h0;
            repeat(5) @(posedge clk);
            rst_n = 1;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Transmitting 0x55 (01010101)", test_num);
            reset_dut();

            data_in = 8'h55;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;


            wait(busy == 1);

            wait(busy == 0);


            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transmitting 0xAA (10101010)", test_num);
            reset_dut();

            data_in = 8'hAA;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;

            wait(busy == 1);
            wait(busy == 0);

            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transmitting 0x00", test_num);
            reset_dut();

            data_in = 8'h00;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;

            wait(busy == 1);
            wait(busy == 0);

            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Transmitting 0xFF", test_num);
            reset_dut();

            data_in = 8'hFF;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;

            wait(busy == 1);
            wait(busy == 0);

            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Attempting to send while module is busy", test_num);
            reset_dut();


            data_in = 8'h12;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;


            wait(busy == 1);
            repeat(20) @(posedge clk);


            data_in = 8'h34;
            send = 1;
            @(posedge clk);
            send = 0;


            wait(busy == 0);

            repeat(10) @(posedge clk);

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
        $dumpvars(0,clk, data_in, rst_n, send, busy, tx);
    end

endmodule
