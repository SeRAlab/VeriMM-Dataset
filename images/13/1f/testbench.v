`timescale 1ns/1ps

module uart_tx_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg send;
    wire transmitting;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_tx dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .send(send),
        .transmitting(transmitting),
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
            data_in = 8'h00;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmit 0x55 and check completion", test_num);
            reset_dut();
            data_in = 8'h55;
            @(posedge clk);
            #1 send = 1;
            @(posedge clk);
            #1 send = 0;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmit 0x00 and check idle state", test_num);
            reset_dut();
            data_in = 8'h00;
            @(posedge clk);
            #1 send = 1;
            @(posedge clk);
            #1 send = 0;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmit 0xFF and check idle state", test_num);
            reset_dut();
            data_in = 8'hFF;
            @(posedge clk);
            #1 send = 1;
            @(posedge clk);
            #1 send = 0;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check transmitting flag during Start Bit", test_num);
            reset_dut();
            data_in = 8'hAA;
            @(posedge clk);
            #1 send = 1;
            @(posedge clk);
            #1 send = 0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check transmitting flag during Data Bit 4", test_num);
            reset_dut();
            data_in = 8'hF0;
            @(posedge clk);
            #1 send = 1;
            @(posedge clk);
            #1 send = 0;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Back-to-back transmission", test_num);
            reset_dut();

            data_in = 8'hA5;
            @(posedge clk);
            #1 send = 1;
            @(posedge clk);
            #1 send = 0;
            repeat (10) @(posedge clk);


            data_in = 8'h5A;
            #1 send = 1;
            @(posedge clk);
            #1 send = 0;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'bx);


            repeat (6) @(posedge clk);
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
        $display("uart_tx Testbench");
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
        input expected_transmitting;
        input expected_tx;
        begin
            if (expected_transmitting === (expected_transmitting ^ transmitting ^ expected_transmitting) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: transmitting=%b, tx=%b",
                         transmitting, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: transmitting=%b, tx=%b",
                         expected_transmitting, expected_tx);
                $display("  Got:      transmitting=%b, tx=%b",
                         transmitting, tx);
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
        $dumpvars(0,clk, data_in, reset, send, transmitting, tx);
    end

endmodule
