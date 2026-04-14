`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg transmit_en;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .transmit_en(transmit_en),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            transmit_en = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 8'hFF;
            transmit_en = 1;
            @(posedge clk);
            transmit_en = 0;


            wait(tx == 0);
            #(BIT_PERIOD / 2);

            $display("Testcase %03d: Checking Start Bit", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 8'h01;
            transmit_en = 1;
            @(posedge clk);
            transmit_en = 0;

            wait(tx == 0);
            #(BIT_PERIOD + BIT_PERIOD / 2);

            $display("Testcase %03d: Checking Bit 0 (LSB) for data 0x01", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 8'h00;
            transmit_en = 1;
            @(posedge clk);
            transmit_en = 0;

            wait(tx == 0);
            #(9 * BIT_PERIOD + BIT_PERIOD / 2);

            $display("Testcase %03d: Checking Stop Bit", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 8'h80;
            transmit_en = 1;
            @(posedge clk);
            transmit_en = 0;

            wait(tx == 0);
            #(8 * BIT_PERIOD + BIT_PERIOD / 2);

            $display("Testcase %03d: Checking Bit 7 (MSB) for data 0x80", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 8'hF7;
            transmit_en = 1;
            @(posedge clk);
            transmit_en = 0;

            wait(tx == 0);
            #(4 * BIT_PERIOD + BIT_PERIOD / 2);

            $display("Testcase %03d: Checking Bit 3 for data 0xF7", test_num);
            #1;

            check_outputs(1'b0);
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
        $dumpvars(0,clk, data_in, transmit_en, tx);
    end

endmodule
