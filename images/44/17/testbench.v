`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] avs_gpio_address;
    reg [3:0] avs_gpio_byteenable;
    reg avs_gpio_read;
    reg avs_gpio_write;
    reg [31:0] avs_gpio_writedata;
    reg csi_MCLK_clk;
    reg rsi_MRST_reset;
    wire [31:0] avs_gpio_readdata;
    wire avs_gpio_waitrequest;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avs_gpio_address(avs_gpio_address),
        .avs_gpio_byteenable(avs_gpio_byteenable),
        .avs_gpio_read(avs_gpio_read),
        .avs_gpio_write(avs_gpio_write),
        .avs_gpio_writedata(avs_gpio_writedata),
        .csi_MCLK_clk(csi_MCLK_clk),
        .rsi_MRST_reset(rsi_MRST_reset),
        .avs_gpio_readdata(avs_gpio_readdata),
        .avs_gpio_waitrequest(avs_gpio_waitrequest)
    );

    // Clock generation (10ns period)
    initial begin
        csi_MCLK_clk = 0;
        forever #5 csi_MCLK_clk = ~csi_MCLK_clk;
    end

        task reset_dut;

    begin
        rsi_MRST_reset = 1;
        avs_gpio_address = 0;
        avs_gpio_byteenable = 0;
        avs_gpio_read = 0;
        avs_gpio_write = 0;
        avs_gpio_writedata = 0;
        tb_drive_en = 0;
        tb_drive_val = 0;
        #20 rsi_MRST_reset = 0;
        @(posedge csi_MCLK_clk);
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Check Reset Default State");
        reset_dut();
        avs_read(3'b001);
        #1;

        check_outputs(32'h00000000, 0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Output Mode Configuration");
        reset_dut();
        avs_write(3'b001, 32'h000000FF, 4'b1111);
        avs_write(3'b000, 32'h000000A5, 4'b1111);
        avs_read(3'b000);
        #1;

        check_outputs(32'h000000A5, 0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Input Mode Reading");
        reset_dut();
        avs_write(3'b001, 32'h00000000, 4'b1111);
        tb_drive_en = 8'hFF;
        tb_drive_val = 8'h5A;
        #10;
        avs_read(3'b000);
        #1;

        check_outputs(32'h0000005A, 0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Byte Enable Verification");
        reset_dut();

        avs_write(3'b001, 32'hFFFFFFFF, 4'b0001);
        avs_read(3'b001);

        #1;


        check_outputs(32'h000000FF, 0);
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
        input [31:0] expected_avs_gpio_readdata;
        input expected_avs_gpio_waitrequest;
        begin
            if (expected_avs_gpio_readdata === (expected_avs_gpio_readdata ^ avs_gpio_readdata ^ expected_avs_gpio_readdata) &&
                expected_avs_gpio_waitrequest === (expected_avs_gpio_waitrequest ^ avs_gpio_waitrequest ^ expected_avs_gpio_waitrequest)) begin
                $display("PASS");
                $display("  Outputs: avs_gpio_readdata=%h, avs_gpio_waitrequest=%b",
                         avs_gpio_readdata, avs_gpio_waitrequest);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avs_gpio_readdata=%h, avs_gpio_waitrequest=%b",
                         expected_avs_gpio_readdata, expected_avs_gpio_waitrequest);
                $display("  Got:      avs_gpio_readdata=%h, avs_gpio_waitrequest=%b",
                         avs_gpio_readdata, avs_gpio_waitrequest);
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
        $dumpvars(0,avs_gpio_address, avs_gpio_byteenable, avs_gpio_read, avs_gpio_write, avs_gpio_writedata, csi_MCLK_clk, rsi_MRST_reset, avs_gpio_readdata, avs_gpio_waitrequest);
    end

endmodule
