`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mosi;
    reg rst_n;
    reg sck;
    reg ssel;
    wire miso;
    wire recived_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mosi(mosi),
        .rst_n(rst_n),
        .sck(sck),
        .ssel(ssel),
        .miso(miso),
        .recived_status(recived_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            sck = 0;
            mosi = 0;
            ssel = 1;
            #20;
            rst_n = 1;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Standard 8-bit transfer (0xA5)", test_num);
            reset_dut();
            spi_transfer_byte(8'hA5);

            #1;


            check_outputs(miso, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Partial 4-bit transfer", test_num);
            reset_dut();
            ssel = 0;
            #20;
            for (i = 0; i < 4; i = i + 1) begin
                mosi = i[0];
                #20 sck = 1;
                #20 sck = 0;
            end
            ssel = 1;
            #40;

            #1;


            check_outputs(miso, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Transfer with ssel=1 (Inactive)", test_num);
            reset_dut();
            ssel = 1;
            #20;
            for (i = 0; i < 8; i = i + 1) begin
                mosi = 1'b1;
                #20 sck = 1;
                #20 sck = 0;
            end
            #40;

            #1;


            check_outputs(miso, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple bytes back-to-back", test_num);
            reset_dut();
            spi_transfer_byte(8'h12);
            spi_transfer_byte(8'h34);

            #1;


            check_outputs(miso, 1'b1);
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
        input expected_recived_status;
        begin
            if (expected_miso === (expected_miso ^ miso ^ expected_miso) &&
                expected_recived_status === (expected_recived_status ^ recived_status ^ expected_recived_status)) begin
                $display("PASS");
                $display("  Outputs: miso=%b, recived_status=%b",
                         miso, recived_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: miso=%b, recived_status=%b",
                         expected_miso, expected_recived_status);
                $display("  Got:      miso=%b, recived_status=%b",
                         miso, recived_status);
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
        $dumpvars(0,clk, mosi, rst_n, sck, ssel, miso, recived_status);
    end

endmodule
