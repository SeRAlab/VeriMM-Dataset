`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg [3:0] data_in;
    reg miso;
    wire [3:0] data_out;
    wire mosi;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .cs(cs),
        .data_in(data_in),
        .miso(miso),
        .data_out(data_out),
        .mosi(mosi)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        cs = 0;
        data_in = 4'b0;
        miso = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

        integer i;
        reg [3:0] tx_val;
        reg [3:0] rx_val;
        begin
            test_num = test_num + 1;
            tx_val = 4'b1010;
            rx_val = 4'b0101;
            $display("Running testcase001: TX %b, RX %b", tx_val, rx_val);
            reset_dut();

            data_in = tx_val;
            cs = 1;

            for (i = 3; i >= 0; i = i - 1) begin

                miso = rx_val[i];
                @(posedge clk);

                @(negedge clk);
            end

            cs = 0;
            #1;
            #1;

            check_outputs(rx_val, tx_val[0]);
        end
        endtask

    task testcase002;

        integer i;
        reg [3:0] tx_val;
        reg [3:0] rx_val;
        begin
            test_num = test_num + 1;
            tx_val = 4'b1111;
            rx_val = 4'b0000;
            $display("Running testcase002: TX %b, RX %b", tx_val, rx_val);
            reset_dut();

            data_in = tx_val;
            cs = 1;

            for (i = 3; i >= 0; i = i - 1) begin
                miso = rx_val[i];
                @(posedge clk);
                @(negedge clk);
            end

            cs = 0;
            #1;
            #1;

            check_outputs(rx_val, tx_val[0]);
        end
        endtask

    task testcase003;

        integer i;
        reg [3:0] tx_val;
        reg [3:0] rx_val;
        begin
            test_num = test_num + 1;
            tx_val = 4'b0000;
            rx_val = 4'b1111;
            $display("Running testcase003: TX %b, RX %b", tx_val, rx_val);
            reset_dut();

            data_in = tx_val;
            cs = 1;

            for (i = 3; i >= 0; i = i - 1) begin
                miso = rx_val[i];
                @(posedge clk);
                @(negedge clk);
            end

            cs = 0;
            #1;
            #1;

            check_outputs(rx_val, tx_val[0]);
        end
        endtask

    task testcase004;

        integer i;
        reg [3:0] tx_val;
        reg [3:0] rx_val;
        begin
            test_num = test_num + 1;
            tx_val = 4'b0110;
            rx_val = 4'b1001;
            $display("Running testcase004: TX %b, RX %b", tx_val, rx_val);
            reset_dut();

            data_in = tx_val;
            cs = 1;

            for (i = 3; i >= 0; i = i - 1) begin
                miso = rx_val[i];
                @(posedge clk);
                @(negedge clk);
            end

            cs = 0;
            #1;
            #1;

            check_outputs(rx_val, tx_val[0]);
        end
        endtask

    task testcase005;

        integer i;
        reg [3:0] tx_val;
        reg [3:0] rx_val;
        begin
            test_num = test_num + 1;
            tx_val = 4'b1001;
            rx_val = 4'b1100;
            $display("Running testcase005: TX %b, RX %b", tx_val, rx_val);
            reset_dut();

            data_in = tx_val;
            cs = 1;

            for (i = 3; i >= 0; i = i - 1) begin
                miso = rx_val[i];
                @(posedge clk);
                @(negedge clk);
            end

            cs = 0;
            #1;
            #1;

            check_outputs(rx_val, tx_val[0]);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_master Testbench");
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
        input [3:0] expected_data_out;
        input expected_mosi;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, mosi=%b",
                         data_out, mosi);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, mosi=%b",
                         expected_data_out, expected_mosi);
                $display("  Got:      data_out=%h, mosi=%b",
                         data_out, mosi);
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
        $dumpvars(0,clk, cs, data_in, miso, data_out, mosi);
    end

endmodule
