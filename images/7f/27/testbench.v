`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg chipselect;
    reg clk;
    reg in_port;
    reg reset_n;
    reg write_n;
    reg [31:0] writedata;
    wire irq;
    wire [31:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .chipselect(chipselect),
        .clk(clk),
        .in_port(in_port),
        .reset_n(reset_n),
        .write_n(write_n),
        .writedata(writedata),
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
        reset_n = 0;
        address = 0;
        chipselect = 0;
        in_port = 0;
        write_n = 1;
        writedata = 0;
        repeat(2) @(posedge clk);
        #1 reset_n = 1;
        repeat(1) @(posedge clk);
    end
        endtask
    task write_reg;

        input [1:0] addr;
        input [31:0] data;
        begin
            @(posedge clk);
            #1;
            address = addr;
            writedata = data;
            chipselect = 1;
            write_n = 0;
            @(posedge clk);
            #1;
            chipselect = 0;
            write_n = 1;
        end
        endtask

    task start_read;

        input [1:0] addr;
        begin
            @(posedge clk);
            #1;
            address = addr;
            chipselect = 1;
            write_n = 1;
        end
        endtask

    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %03d: Reset State Check", test_num);
        start_read(ADDR_DATA);
        @(posedge clk); #1;
        #1;

        check_outputs(1'b0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %03d: Data Port Reading", test_num);
        in_port = 1;
        repeat(2) @(posedge clk);
        start_read(ADDR_DATA);
        @(posedge clk); #1;
        #1;

        check_outputs(1'b0, 32'h1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %03d: Edge Capture without Mask", test_num);

        in_port = 1;
        repeat(2) @(posedge clk);

        start_read(ADDR_EDGE);
        @(posedge clk); #1;
        #1;

        check_outputs(1'b0, 32'h1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %03d: IRQ Generation with Mask", test_num);

        write_reg(ADDR_MASK, 32'h1);

        in_port = 1;
        repeat(3) @(posedge clk);

        start_read(ADDR_DATA);
        @(posedge clk); #1;
        #1;

        check_outputs(1'b1, 32'h1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %03d: Clear Edge Capture and IRQ", test_num);

        write_reg(ADDR_MASK, 32'h1);

        in_port = 1;
        repeat(2) @(posedge clk);

        write_reg(ADDR_EDGE, 32'h1);
        repeat(2) @(posedge clk);

        start_read(ADDR_EDGE);
        @(posedge clk); #1;
        #1;

        check_outputs(1'b0, 32'h0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %03d: Mask Register R/W", test_num);
        write_reg(ADDR_MASK, 32'hAAAA_5555);
        start_read(ADDR_MASK);
        @(posedge clk); #1;
        #1;

        check_outputs(1'b0, 32'hAAAA_5555);
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
        testcase006();
        
        
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
        input expected_irq;
        input [31:0] expected_readdata;
        begin
            if (expected_irq === (expected_irq ^ irq ^ expected_irq) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: irq=%b, readdata=%h",
                         irq, readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: irq=%b, readdata=%h",
                         expected_irq, expected_readdata);
                $display("  Got:      irq=%b, readdata=%h",
                         irq, readdata);
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
        $dumpvars(0,address, chipselect, clk, in_port, reset_n, write_n, writedata, irq, readdata);
    end

endmodule
