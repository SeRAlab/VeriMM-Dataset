`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ack_i;
    reg clk;
    reg [7:0] data_i;
    reg mosi;
    reg sck;
    reg ss;
    wire ack_pop_o;
    wire [7:0] data_o;
    wire miso;
    wire rst_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ack_i(ack_i),
        .clk(clk),
        .data_i(data_i),
        .mosi(mosi),
        .sck(sck),
        .ss(ss),
        .ack_pop_o(ack_pop_o),
        .data_o(data_o),
        .miso(miso),
        .rst_o(rst_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ack_i = 0;
            data_i = 8'h00;
            mosi = 0;
            sck = 0;
            ss = 1;
            repeat(5) @(posedge clk);
        end
        endtask
    task spi_transfer;

        input [7:0] mosi_byte;
        integer i;
        begin

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = mosi_byte[i];
                repeat(5) @(posedge clk);
                sck = 1;
                repeat(5) @(posedge clk);
                sck = 0;
                repeat(5) @(posedge clk);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            data_i = 8'hA5;
            ack_i = 1;
            @(posedge clk);
            ack_i = 0;


            ss = 0;
            repeat(5) @(posedge clk);

            spi_transfer(8'h5A);

            repeat(5) @(posedge clk);
            ss = 1;
            repeat(5) @(posedge clk);




            #1;





            check_outputs(1'b0, 8'h5A, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            data_i = 8'h00;
            ack_i = 1;
            @(posedge clk);
            ack_i = 0;

            ss = 0;
            repeat(5) @(posedge clk);

            spi_transfer(8'hFF);

            repeat(5) @(posedge clk);
            ss = 1;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'hFF, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            data_i = 8'hFF;
            ack_i = 1;
            @(posedge clk);
            ack_i = 0;

            ss = 0;
            repeat(5) @(posedge clk);

            spi_transfer(8'h00);

            repeat(5) @(posedge clk);
            ss = 1;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            data_i = 8'h55;
            ack_i = 1;
            @(posedge clk);
            ack_i = 0;

            ss = 0;
            repeat(5) @(posedge clk);

            spi_transfer(8'hAA);

            repeat(5) @(posedge clk);
            ss = 1;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'hAA, 1'b1, 1'b1);
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
        input expected_ack_pop_o;
        input [7:0] expected_data_o;
        input expected_miso;
        input expected_rst_o;
        begin
            if (expected_ack_pop_o === (expected_ack_pop_o ^ ack_pop_o ^ expected_ack_pop_o) &&
                expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso) &&
                expected_rst_o === (expected_rst_o ^ rst_o ^ expected_rst_o)) begin
                $display("PASS");
                $display("  Outputs: ack_pop_o=%b, data_o=%h, miso=%b, rst_o=%b",
                         ack_pop_o, data_o, miso, rst_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_pop_o=%b, data_o=%h, miso=%b, rst_o=%b",
                         expected_ack_pop_o, expected_data_o, expected_miso, expected_rst_o);
                $display("  Got:      ack_pop_o=%b, data_o=%h, miso=%b, rst_o=%b",
                         ack_pop_o, data_o, miso, rst_o);
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
        $dumpvars(0,ack_i, clk, data_i, mosi, sck, ss, ack_pop_o, data_o, miso, rst_o);
    end

endmodule
