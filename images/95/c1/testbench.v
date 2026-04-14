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
    wire frame_end;
    wire frame_start;
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
        .frame_end(frame_end),
        .frame_start(frame_start),
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
            sck = 0;
            mosi = 0;
            din = 0;
            repeat(5) @(posedge clk);
            rst = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task spi_transfer;

        input [7:0] mosi_data;
        input [7:0] slave_din;
        integer i;
        begin
            din = slave_din;
            #20;
            ss = 0;
            #50;
            for (i = 7; i >= 0; i = i - 1) begin
                mosi = mosi_data[i];
                #50;
                sck = 1;
                #50;
                sck = 0;
                #50;
            end
            #20;
            ss = 1;
            #20;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %03d: Basic Transfer 0x35", test_num);
            spi_transfer(8'h35, 8'h01);

            #1;


            check_outputs(1'b1, 8'h35, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %03d: Basic Transfer 0x8A", test_num);
            spi_transfer(8'h8A, 8'hFE);

            #1;


            check_outputs(1'b1, 8'h8A, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %03d: All Ones Transfer", test_num);
            spi_transfer(8'hFF, 8'hAA);

            #1;


            check_outputs(1'b1, 8'hFF, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %03d: All Zeros Transfer", test_num);
            spi_transfer(8'h00, 8'h55);

            #1;


            check_outputs(1'b1, 8'h00, 1'b1, 1'b0, 1'b1);
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
        input expected_done;
        input [7:0] expected_dout;
        input expected_frame_end;
        input expected_frame_start;
        input expected_miso;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_frame_end === (expected_frame_end ^ frame_end ^ expected_frame_end) &&
                expected_frame_start === (expected_frame_start ^ frame_start ^ expected_frame_start) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: done=%b, dout=%h, frame_end=%b, frame_start=%b, miso=%b",
                         done, dout, frame_end, frame_start, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, dout=%h, frame_end=%b, frame_start=%b, miso=%b",
                         expected_done, expected_dout, expected_frame_end, expected_frame_start, expected_miso);
                $display("  Got:      done=%b, dout=%h, frame_end=%b, frame_start=%b, miso=%b",
                         done, dout, frame_end, frame_start, miso);
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
        $dumpvars(0,clk, din, mosi, rst, sck, ss, done, dout, frame_end, frame_start, miso);
    end

endmodule
