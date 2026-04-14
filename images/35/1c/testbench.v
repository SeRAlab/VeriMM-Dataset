`timescale 1ns/1ps

module uart_tx_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg send;
    wire busy;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_tx dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
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
            rst = 1;
            send = 0;
            data_in = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            $display("  Reset complete.");
        end
        endtask
    task run_uart_test;

        input [7:0] data;
        reg stream_match;
        integer i;
        begin
            stream_match = 1;
            test_num = test_num + 1;
            $display("Testcase %0d: Sending Data 8'h%h (%b)", test_num, data, data);

            reset_dut();
            data_in = data;


            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;


            wait(busy === 1);
            #2;
            if (tx !== 1'b0) begin
                $display("  Error: Start bit not detected (tx=%b)", tx);
                stream_match = 0;
            end
            @(posedge clk);


            for (i = 0; i < 8; i = i + 1) begin
                #2;
                if (tx !== data[i]) begin
                    $display("  Error: Data bit %0d mismatch. Expected %b, Got %b", i, data[i], tx);
                    stream_match = 0;
                end
                @(posedge clk);
            end


            #2;
            if (tx !== 1'b1) begin
                $display("  Error: Stop bit not detected (tx=%b)", tx);
                stream_match = 0;
            end


            wait(busy === 0);
            @(posedge clk);
            #1;


            if (stream_match)
                #1;

                check_outputs(1'b0, 1'b1);
            else
                #1;

                check_outputs(1'b0, 1'b0);
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
        $dumpvars(0,clk, data_in, rst, send, busy, tx);
    end

endmodule
