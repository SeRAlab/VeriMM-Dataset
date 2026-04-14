`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg OTG_INT0;
    reg OTG_INT1;
    reg [1:0] address;
    reg chipselect;
    reg clk;
    reg read;
    reg reset;
    reg write;
    reg [15:0] writedata;
    wire [1:0] OTG_ADDR;
    wire OTG_CS_N;
    wire OTG_RD_N;
    wire OTG_RST_N;
    wire OTG_WR_N;
    wire irq;
    wire [15:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .OTG_INT0(OTG_INT0),
        .OTG_INT1(OTG_INT1),
        .address(address),
        .chipselect(chipselect),
        .clk(clk),
        .read(read),
        .reset(reset),
        .write(write),
        .writedata(writedata),
        .OTG_ADDR(OTG_ADDR),
        .OTG_CS_N(OTG_CS_N),
        .OTG_RD_N(OTG_RD_N),
        .OTG_RST_N(OTG_RST_N),
        .OTG_WR_N(OTG_WR_N),
        .irq(irq),
        .readdata(readdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        address = 0;
        chipselect = 0;
        read = 0;
        write = 0;
        writedata = 0;
        OTG_INT0 = 1;
        OTG_INT1 = 1;
        otg_data_en = 0;
        otg_data_drive_reg = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;


        #1;



        check_outputs(2'b00, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        @(posedge clk);
        address = 2'b01;
        writedata = 16'hA5A5;
        chipselect = 1;
        write = 1;

        repeat(2) @(posedge clk);


        #1;



        check_outputs(2'b01, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 16'h0000);


        write = 0;
        chipselect = 0;
        repeat(1) @(posedge clk);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        @(posedge clk);
        address = 2'b11;
        chipselect = 1;
        read = 1;


        otg_data_en = 1;
        otg_data_drive_reg = 16'h5A5A;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(2'b11, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 16'h5A5A);

        read = 0;
        chipselect = 0;
        otg_data_en = 0;
        repeat(1) @(posedge clk);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        @(posedge clk);

        OTG_INT0 = 0;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(2'b00, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 16'h0000);

        OTG_INT0 = 1;
        repeat(1) @(posedge clk);
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
        input [1:0] expected_OTG_ADDR;
        input expected_OTG_CS_N;
        input expected_OTG_RD_N;
        input expected_OTG_RST_N;
        input expected_OTG_WR_N;
        input expected_irq;
        input [15:0] expected_readdata;
        begin
            if (expected_OTG_ADDR === (expected_OTG_ADDR ^ OTG_ADDR ^ expected_OTG_ADDR) &&
                expected_OTG_CS_N === (expected_OTG_CS_N ^ OTG_CS_N ^ expected_OTG_CS_N) &&
                expected_OTG_RD_N === (expected_OTG_RD_N ^ OTG_RD_N ^ expected_OTG_RD_N) &&
                expected_OTG_RST_N === (expected_OTG_RST_N ^ OTG_RST_N ^ expected_OTG_RST_N) &&
                expected_OTG_WR_N === (expected_OTG_WR_N ^ OTG_WR_N ^ expected_OTG_WR_N) &&
                expected_irq === (expected_irq ^ irq ^ expected_irq) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: OTG_ADDR=%h, OTG_CS_N=%b, OTG_RD_N=%b, OTG_RST_N=%b, OTG_WR_N=%b, irq=%b, readdata=%h",
                         OTG_ADDR, OTG_CS_N, OTG_RD_N, OTG_RST_N, OTG_WR_N, irq, readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OTG_ADDR=%h, OTG_CS_N=%b, OTG_RD_N=%b, OTG_RST_N=%b, OTG_WR_N=%b, irq=%b, readdata=%h",
                         expected_OTG_ADDR, expected_OTG_CS_N, expected_OTG_RD_N, expected_OTG_RST_N, expected_OTG_WR_N, expected_irq, expected_readdata);
                $display("  Got:      OTG_ADDR=%h, OTG_CS_N=%b, OTG_RD_N=%b, OTG_RST_N=%b, OTG_WR_N=%b, irq=%b, readdata=%h",
                         OTG_ADDR, OTG_CS_N, OTG_RD_N, OTG_RST_N, OTG_WR_N, irq, readdata);
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
        $dumpvars(0,OTG_INT0, OTG_INT1, address, chipselect, clk, read, reset, write, writedata, OTG_ADDR, OTG_CS_N, OTG_RD_N, OTG_RST_N, OTG_WR_N, irq, readdata);
    end

endmodule
