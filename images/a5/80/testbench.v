`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [1:0] data_length;
    reg data_ready;
    reg mosi;
    reg rst_n;
    reg sclk;
    reg ss;
    wire [15:0] data_out;
    wire data_valid;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_length(data_length),
        .data_ready(data_ready),
        .mosi(mosi),
        .rst_n(rst_n),
        .sclk(sclk),
        .ss(ss),
        .data_out(data_out),
        .data_valid(data_valid),
        .miso(miso)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            ss = 1;
            sclk = 0;
            mosi = 0;
            data_in = 0;
            data_length = 0;
            data_ready = 0;
            #20 rst_n = 1;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            data_in = 16'hAA00;
            data_ready = 1;
            @(posedge clk);
            data_ready = 0;


            data_length = 2'b00;


            spi_master_send(16'h003C, 8);



            #1;




            check_outputs(16'h003C, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            data_in = 16'hF0F0;
            data_ready = 1;
            @(posedge clk);
            data_ready = 0;


            data_length = 2'b01;


            spi_master_send(16'h1234, 16);

            #1;


            check_outputs(16'h1234, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();



            #1;




            check_outputs(16'h0000, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            data_in = 16'hFFFF;
            data_ready = 1;
            @(posedge clk);
            data_ready = 0;

            data_length = 2'b00;


            spi_master_send(16'h00FF, 8);

            #1;


            check_outputs(16'h00FF, 1'b1, 1'b1);
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
        input [15:0] expected_data_out;
        input expected_data_valid;
        input expected_miso;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_valid=%b, miso=%b",
                         data_out, data_valid, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_valid=%b, miso=%b",
                         expected_data_out, expected_data_valid, expected_miso);
                $display("  Got:      data_out=%h, data_valid=%b, miso=%b",
                         data_out, data_valid, miso);
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
        $dumpvars(0,clk, data_in, data_length, data_ready, mosi, rst_n, sclk, ss, data_out, data_valid, miso);
    end

endmodule
