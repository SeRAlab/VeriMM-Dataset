`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] rdat;
    reg reset;
    reg spiclk;
    reg spicsl;
    reg spimosi;
    wire [6:0] addr;
    wire re;
    wire spimiso;
    wire [31:0] wdat;
    wire we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rdat(rdat),
        .reset(reset),
        .spiclk(spiclk),
        .spicsl(spicsl),
        .spimosi(spimosi),
        .addr(addr),
        .re(re),
        .spimiso(spimiso),
        .wdat(wdat),
        .we(we)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            spiclk = 0;
            spicsl = 1;
            spimosi = 0;
            rdat = 32'h0;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task spi_transaction;

        input is_write;
        input [6:0] address;
        input [31:0] data_in;
        integer i;
        reg [7:0] header;
        begin
            header = {is_write, address};
            spicsl = 0;
            #20;

            for (i = 7; i >= 0; i = i - 1) begin
                spimosi = header[i];
                #20; spiclk = 1; #20; spiclk = 0;
            end

            for (i = 31; i >= 0; i = i - 1) begin
                spimosi = data_in[i];
                #20; spiclk = 1; #20; spiclk = 0;
            end
            #20;
            spicsl = 1;
            #40;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: SPI Write to Address 0x12");

            spi_transaction(1'b1, 7'h12, 32'hA5A55A5A);

            #1;


            check_outputs(7'h12, 1'b0, spimiso, 32'hA5A55A5A, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: SPI Read from Address 0x3F");
            rdat = 32'h12345678;

            spi_transaction(1'b0, 7'h3F, 32'h0);

            #1;


            check_outputs(7'h3F, 1'b1, spimiso, 32'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: SPI Write to Address 0x7F (Max)");
            spi_transaction(1'b1, 7'h7F, 32'hFFFFFFFF);
            #1;

            check_outputs(7'h7F, 1'b0, spimiso, 32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Consecutive Write then Read");

            spi_transaction(1'b1, 12, 32'hCAFEFACE);

            if (we === 1 && addr === 12 && wdat === 32'hCAFEFACE) begin

                spi_transaction(1'b0, 45, 32'h0);
                #1;

                check_outputs(7'h2D, 1'b1, spimiso, 32'h0, 1'b0);
            end else begin
                $display("FAIL: Initial write failed");
                fail_count = fail_count + 1;
            end
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
        input [6:0] expected_addr;
        input expected_re;
        input expected_spimiso;
        input [31:0] expected_wdat;
        input expected_we;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr) &&
                expected_re === (expected_re ^ re ^ expected_re) &&
                expected_spimiso === (expected_spimiso ^ spimiso ^ expected_spimiso) &&
                expected_wdat === (expected_wdat ^ wdat ^ expected_wdat) &&
                expected_we === (expected_we ^ we ^ expected_we)) begin
                $display("PASS");
                $display("  Outputs: addr=%h, re=%b, spimiso=%b, wdat=%h, we=%b",
                         addr, re, spimiso, wdat, we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h, re=%b, spimiso=%b, wdat=%h, we=%b",
                         expected_addr, expected_re, expected_spimiso, expected_wdat, expected_we);
                $display("  Got:      addr=%h, re=%b, spimiso=%b, wdat=%h, we=%b",
                         addr, re, spimiso, wdat, we);
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
        $dumpvars(0,clk, rdat, reset, spiclk, spicsl, spimosi, addr, re, spimiso, wdat, we);
    end

endmodule
