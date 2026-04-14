`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    reg sck;
    reg sdi;
    reg ss_n;
    wire [7:0] adrs;
    wire [7:0] data;
    wire rx_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset_n(reset_n),
        .sck(sck),
        .sdi(sdi),
        .ss_n(ss_n),
        .adrs(adrs),
        .data(data),
        .rx_valid(rx_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            sck = 0;
            sdi = 0;
            ss_n = 1;
            #20;
            reset_n = 1;
            #20;
        end
        endtask
    task send_spi_byte;

        input [7:0] byte_data;
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                sdi = byte_data[i];
                #50;
                sck = 1;
                #100;
                sck = 0;
                #50;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Standard 16-bit Transmission", test_num);
            reset_dut();

            ss_n = 0;
            #50;
            send_spi_byte(8'hA5);
            send_spi_byte(8'h3C);
            #50;
            ss_n = 1;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(8'hA5, 8'h3C, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Different Address and Data values", test_num);
            reset_dut();

            ss_n = 0;
            #50;
            send_spi_byte(8'hFF);
            send_spi_byte(8'h12);
            #50;
            ss_n = 1;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'hFF, 8'h12, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Incomplete transmission with SS_N toggle", test_num);
            reset_dut();


            ss_n = 0;
            send_spi_byte(8'hAA);
            ss_n = 1;
            #100;


            ss_n = 0;
            send_spi_byte(8'h0F);
            send_spi_byte(8'hF0);
            #50;
            ss_n = 1;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(8'h0F, 8'hF0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Zero values test", test_num);
            reset_dut();

            ss_n = 0;
            #50;
            send_spi_byte(8'h00);
            send_spi_byte(8'h00);
            #50;
            ss_n = 1;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h00, 8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Asynchronous Reset mid-transmission", test_num);
            reset_dut();

            ss_n = 0;
            send_spi_byte(8'h55);


            #10;
            reset_n = 0;
            #50;
            reset_n = 1;


            send_spi_byte(8'h66);
            ss_n = 1;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(8'h00, 8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_adrs;
        input [7:0] expected_data;
        input expected_rx_valid;
        begin
            if (expected_adrs === (expected_adrs ^ adrs ^ expected_adrs) &&
                expected_data === (expected_data ^ data ^ expected_data) &&
                expected_rx_valid === (expected_rx_valid ^ rx_valid ^ expected_rx_valid)) begin
                $display("PASS");
                $display("  Outputs: adrs=%h, data=%h, rx_valid=%b",
                         adrs, data, rx_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adrs=%h, data=%h, rx_valid=%b",
                         expected_adrs, expected_data, expected_rx_valid);
                $display("  Got:      adrs=%h, data=%h, rx_valid=%b",
                         adrs, data, rx_valid);
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
        $dumpvars(0,clk, reset_n, sck, sdi, ss_n, adrs, data, rx_valid);
    end

endmodule
