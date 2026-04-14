`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cpha;
    reg cpol;
    reg reset;
    reg start;
    reg [7:0] tx_data;
    wire busy;
    wire cs_n;
    wire miso;
    wire mosi;
    wire [7:0] rx_data;
    wire sclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .cpha(cpha),
        .cpol(cpol),
        .reset(reset),
        .start(start),
        .tx_data(tx_data),
        .busy(busy),
        .cs_n(cs_n),
        .miso(miso),
        .mosi(mosi),
        .rx_data(rx_data),
        .sclk(sclk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            tx_data = 8'h00;
            cpol = 0;
            cpha = 0;
            miso_driver = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task slave_response;

        input [7:0] data_to_send;
        input mode_cpol;
        input mode_cpha;
        integer i;
        begin

            if (mode_cpha == 0) begin
                wait(cs_n == 0);
                miso_driver = data_to_send[7];
                for (i = 6; i >= 0; i = i - 1) begin

                    if (mode_cpol == 0) @(negedge sclk);
                    else @(posedge sclk);
                    miso_driver = data_to_send[i];
                end
            end

            else begin
                wait(cs_n == 0);
                for (i = 7; i >= 0; i = i - 1) begin
                    if (mode_cpol == 0) @(posedge sclk);
                    else @(negedge sclk);
                    miso_driver = data_to_send[i];
                end
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Mode 0 (CPOL=0, CPHA=0) - Transfer 0xA5", test_num);
            reset_dut();
            cpol = 0;
            cpha = 0;
            tx_data = 8'hA5;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            slave_response(8'h5A, 0, 0);

            wait(busy == 0);
            #20;


            #1;



            check_outputs(0, 1, 0, 1, 8'h5A, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Mode 1 (CPOL=0, CPHA=1) - Transfer 0x33", test_num);
            reset_dut();
            cpol = 0;
            cpha = 1;
            tx_data = 8'h33;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            slave_response(8'hCC, 0, 1);

            wait(busy == 0);
            #20;


            #1;



            check_outputs(0, 1, 0, 1, 8'hCC, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Mode 2 (CPOL=1, CPHA=0) - Transfer 0xF0", test_num);
            reset_dut();
            cpol = 1;
            cpha = 0;
            tx_data = 8'hF0;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            slave_response(8'h0F, 1, 0);

            wait(busy == 0);
            #20;


            #1;



            check_outputs(0, 1, 1, 0, 8'h0F, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Mode 3 (CPOL=1, CPHA=1) - Transfer 0xAA", test_num);
            reset_dut();
            cpol = 1;
            cpha = 1;
            tx_data = 8'hAA;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            slave_response(8'h55, 1, 1);

            wait(busy == 0);
            #20;


            #1;



            check_outputs(0, 1, 1, 0, 8'h55, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Idle State Check", test_num);
            reset_dut();
            cpol = 0;
            cpha = 0;
            #100;


            #1;



            check_outputs(0, 1, 0, 0, 8'h00, 0);
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
        input expected_busy;
        input expected_cs_n;
        input expected_miso;
        input expected_mosi;
        input [7:0] expected_rx_data;
        input expected_sclk;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_cs_n === (expected_cs_n ^ cs_n ^ expected_cs_n) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, cs_n=%b, miso=%b, mosi=%b, rx_data=%h, sclk=%b",
                         busy, cs_n, miso, mosi, rx_data, sclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, cs_n=%b, miso=%b, mosi=%b, rx_data=%h, sclk=%b",
                         expected_busy, expected_cs_n, expected_miso, expected_mosi, expected_rx_data, expected_sclk);
                $display("  Got:      busy=%b, cs_n=%b, miso=%b, mosi=%b, rx_data=%h, sclk=%b",
                         busy, cs_n, miso, mosi, rx_data, sclk);
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
        $dumpvars(0,clk, cpha, cpol, reset, start, tx_data, busy, cs_n, miso, mosi, rx_data, sclk);
    end

endmodule
