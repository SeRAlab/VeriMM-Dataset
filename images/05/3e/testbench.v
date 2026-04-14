`timescale 1ns/1ps

module uart_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg receive;
    reg reset;
    reg send;
    wire [7:0] data_out;
    wire data_received;
    wire data_sent;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_controller dut (
        .clk(clk),
        .data_in(data_in),
        .receive(receive),
        .reset(reset),
        .send(send),
        .data_out(data_out),
        .data_received(data_received),
        .data_sent(data_sent),
        .tx(tx)
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
            receive = 1;
            data_in = 8'h00;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Transmitting 8'hA5", test_num);
            reset_dut();

            data_in = 8'hA5;
            send = 1;
            @(posedge clk);
            send = 0;


            wait(data_sent == 1);
            #10;


            #1;



            check_outputs(8'h00, 0, 1, 1);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] rx_pattern;
        begin
            test_num = 2;
            $display("Test Case %0d: Receiving 8'h5A", test_num);
            reset_dut();
            rx_pattern = 8'h5A;


            receive = 0;
            #(BIT_PERIOD);


            for (i = 0; i < 8; i = i + 1) begin
                receive = rx_pattern[i];
                #(BIT_PERIOD);
            end


            receive = 1;
            #(BIT_PERIOD);


            wait(data_received == 1);
            #10;


            #1;



            check_outputs(8'h5A, 1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Transmitting 8'h00", test_num);
            reset_dut();

            data_in = 8'h00;
            send = 1;
            @(posedge clk);
            send = 0;

            wait(data_sent == 1);
            #10;

            #1;


            check_outputs(8'h00, 0, 1, 1);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] rx_pattern;
        begin
            test_num = 4;
            $display("Test Case %0d: Receiving 8'hFF", test_num);
            reset_dut();
            rx_pattern = 8'hFF;

            receive = 0;
            #(BIT_PERIOD);

            for (i = 0; i < 8; i = i + 1) begin
                receive = rx_pattern[i];
                #(BIT_PERIOD);
            end

            receive = 1;
            #(BIT_PERIOD);

            wait(data_received == 1);
            #10;

            #1;


            check_outputs(8'hFF, 1, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_data_received;
        input expected_data_sent;
        input expected_tx;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_received === (expected_data_received ^ data_received ^ expected_data_received) &&
                expected_data_sent === (expected_data_sent ^ data_sent ^ expected_data_sent) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_received=%b, data_sent=%b, tx=%b",
                         data_out, data_received, data_sent, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_received=%b, data_sent=%b, tx=%b",
                         expected_data_out, expected_data_received, expected_data_sent, expected_tx);
                $display("  Got:      data_out=%h, data_received=%b, data_sent=%b, tx=%b",
                         data_out, data_received, data_sent, tx);
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
        $dumpvars(0,clk, data_in, receive, reset, send, data_out, data_received, data_sent, tx);
    end

endmodule
