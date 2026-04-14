`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg din_update;
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
        .din_update(din_update),
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
            din_update = 0;
            repeat(5) @(posedge clk);
            rst = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task spi_transfer;

        input [7:0] mosi_data;
        integer i;
        begin
            @(posedge clk);
            ss = 0;
            repeat(2) @(posedge clk);

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = mosi_data[i];
                repeat(2) @(posedge clk);
                sck = 1;
                repeat(4) @(posedge clk);
                sck = 0;
                repeat(2) @(posedge clk);
            end


            repeat(2) @(posedge clk);


            repeat(2) @(posedge clk);
            ss = 1;
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transferring 0x55", test_num);
            reset_dut();


            din = 8'hAA;
            din_update = 1;
            @(posedge clk);
            din_update = 0;

            spi_transfer(8'h55);




            #1;





            check_outputs(1'b1, 8'h55, miso);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transferring 0xAA", test_num);
            reset_dut();

            din = 8'h55;
            din_update = 1;
            @(posedge clk);
            din_update = 0;

            spi_transfer(8'hAA);

            #1;


            check_outputs(1'b1, 8'hAA, miso);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transferring 0xFF", test_num);
            reset_dut();

            spi_transfer(8'hFF);

            #1;


            check_outputs(1'b1, 8'hFF, miso);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transferring 0x00", test_num);
            reset_dut();

            spi_transfer(8'h00);

            #1;


            check_outputs(1'b1, 8'h00, miso);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transferring 0xA5", test_num);
            reset_dut();

            din = 8'h12;
            din_update = 1;
            @(posedge clk);
            din_update = 0;

            spi_transfer(8'hA5);

            #1;


            check_outputs(1'b1, 8'hA5, miso);
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
        $dumpvars(0,clk, din, din_update, mosi, rst, sck, ss, done, dout, miso);
    end

endmodule
