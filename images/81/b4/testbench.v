`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mosi;
    reg rst;
    reg sck;
    reg ss;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mosi(mosi),
        .rst(rst),
        .sck(sck),
        .ss(ss),
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
            #20;
            rst = 0;
            #10;
        end
        endtask
    task spi_cycle;

        input bit_in;
        begin
            mosi = bit_in;
            #10;
            sck = 1;
            #10;
            sck = 0;
            #10;
        end
        endtask

    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %03d: Normal Full Transaction (TX and RX)", test_num);
            reset_dut();


            ss = 0;
            #10;


            for (i = 0; i < 8; i = i + 1) begin
                spi_cycle($random % 2);
            end


            for (i = 0; i < 8; i = i + 1) begin
                spi_cycle($random % 2);
            end


            #20;
            ss = 1;
            #20;


            #1;



            check_outputs(miso);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %03d: External Reset during TX", test_num);
            reset_dut();

            ss = 0;
            #10;

            for (i = 0; i < 4; i = i + 1) begin
                spi_cycle(1);
            end


            rst = 1;
            #20;
            rst = 0;
            #10;



            #1;




            check_outputs(miso);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %03d: SS de-assertion (Abort)", test_num);
            reset_dut();

            ss = 0;
            #10;

            for (i = 0; i < 6; i = i + 1) begin
                spi_cycle(0);
            end


            ss = 1;
            #20;

            #1;


            check_outputs(miso);
        end
        endtask

    task testcase004;

        integer i, j;
        begin
            test_num = test_num + 1;
            $display("Test %03d: Successive Transactions", test_num);
            reset_dut();

            for (j = 0; j < 2; j = j + 1) begin
                ss = 0;
                #10;

                repeat(16) spi_cycle($random % 2);
                #20;
                ss = 1;
                #20;
            end

            #1;


            check_outputs(miso);
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
        input expected_miso;
        begin
            if (expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: miso=%b",
                         miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: miso=%b",
                         expected_miso);
                $display("  Got:      miso=%b",
                         miso);
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
        $dumpvars(0,clk, mosi, rst, sck, ss, miso);
    end

endmodule
