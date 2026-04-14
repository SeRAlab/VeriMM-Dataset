`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg mosi;
    reg rst;
    reg sck;
    reg ss;
    wire done;
    wire [7:0] dout;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .mosi(mosi),
        .rst(rst),
        .sck(sck),
        .ss(ss),
        .done(done),
        .dout(dout),
        .miso(miso)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ss = 1;
            mosi = 0;
            sck = 0;
            din = 0;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task spi_send_byte;

        input [7:0] data_to_slave;
        integer i;
        begin
            ss = 0;
            #20;
            for (i = 7; i >= 0; i = i - 1) begin
                mosi = data_to_slave[i];
                #20;
                sck = 1;
                #20;
                sck = 0;
                #20;
            end
            #20;
            ss = 1;
            #40;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            din = 8'h5A;
            spi_send_byte(8'hA5);


            #1;



            check_outputs(1'b1, 8'hA5, 8'h5A & 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            din = 8'h00;
            spi_send_byte(8'h00);
            #1;

            check_outputs(1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            din = 8'hFF;
            spi_send_byte(8'hFF);
            #1;

            check_outputs(1'b1, 8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            din = 8'hAA;
            spi_send_byte(8'h55);
            #1;

            check_outputs(1'b1, 8'h55, 8'hAA & 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            din = 8'h12;
            spi_send_byte(8'h34);

            din = 8'h78;
            spi_send_byte(8'h9A);
            #1;

            check_outputs(1'b1, 8'h9A, 8'h78 & 1'b1);
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
        input expected_done;
        input [7:0] expected_dout;
        input expected_miso;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: done=%b, dout=%h, miso=%b",
                         done, dout, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, dout=%h, miso=%b",
                         expected_done, expected_dout, expected_miso);
                $display("  Got:      done=%b, dout=%h, miso=%b",
                         done, dout, miso);
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
        $dumpvars(0,clk, din, mosi, rst, sck, ss, done, dout, miso);
    end

endmodule
