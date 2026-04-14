`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] address;
    reg chipselect;
    reg clk;
    reg [31:0] in_port;
    reg reset_n;
    reg write_n;
    reg [31:0] writedata;
    wire irq;
    wire [31:0] out_port;
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
        .out_port(out_port),
        .readdata(readdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 0;
            chipselect = 0;
            in_port = 0;
            write_n = 1;
            writedata = 0;
            reset_n = 0;
            @(posedge clk);
            #2 reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying initial state after reset...", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Writing to output port...", test_num);
            reset_dut();
            @(negedge clk);
            address = 3'h0;
            writedata = 32'hDEADBEEF;
            chipselect = 1;
            write_n = 0;
            @(posedge clk);
            #2;
            chipselect = 0;
            write_n = 1;


            address = 3'h0;
            chipselect = 1;
            write_n = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Reading from input port...", test_num);
            reset_dut();
            @(negedge clk);
            in_port = 32'h55AA55AA;
            address = 3'h1;
            chipselect = 1;
            write_n = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 32'h0, 32'h55AA55AA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying IRQ assertion with mask...", test_num);
            reset_dut();

            @(negedge clk);
            address = 3'h2;
            writedata = 32'h0000000F;
            chipselect = 1;
            write_n = 0;
            @(posedge clk);
            #2;


            address = 3'h1;
            write_n = 1;
            in_port = 32'h00000001;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'h0, 32'h00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying IRQ remains low if mask doesn't match...", test_num);
            reset_dut();

            @(negedge clk);
            address = 3'h2;
            writedata = 32'h000000F0;
            chipselect = 1;
            write_n = 0;
            @(posedge clk);
            #2;


            address = 3'h1;
            write_n = 1;
            in_port = 32'h0000000F;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 32'h0, 32'h0000000F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying module ignores write when chipselect is low...", test_num);
            reset_dut();
            @(negedge clk);
            address = 3'h0;
            writedata = 32'hFFFFFFFF;
            chipselect = 0;
            write_n = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 32'h0, 32'h0);
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
        input [31:0] expected_out_port;
        input [31:0] expected_readdata;
        begin
            if (expected_irq === (expected_irq ^ irq ^ expected_irq) &&
                expected_out_port === (expected_out_port ^ out_port ^ expected_out_port) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: irq=%b, out_port=%h, readdata=%h",
                         irq, out_port, readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: irq=%b, out_port=%h, readdata=%h",
                         expected_irq, expected_out_port, expected_readdata);
                $display("  Got:      irq=%b, out_port=%h, readdata=%h",
                         irq, out_port, readdata);
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
        $dumpvars(0,address, chipselect, clk, in_port, reset_n, write_n, writedata, irq, out_port, readdata);
    end

endmodule
