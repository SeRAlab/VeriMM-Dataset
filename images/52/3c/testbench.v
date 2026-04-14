`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg chipselect;
    reg clk;
    reg reset_n;
    reg write_n;
    reg [9:0] writedata;
    wire [9:0] out_port;
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
        .reset_n(reset_n),
        .write_n(write_n),
        .writedata(writedata),
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
            reset_n = 1'b0;
            address = 2'b00;
            chipselect = 1'b0;
            write_n = 1'b1;
            writedata = 10'b0;
            @(posedge clk);
            #1 reset_n = 1'b1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(10'h000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Valid Write to Address 0");
            reset_dut();
            address = 2'b00;
            writedata = 10'h3FF;
            chipselect = 1'b1;
            write_n = 1'b0;
            @(posedge clk);
            #2;
            write_n = 1'b1;
            chipselect = 1'b1;
            #1;

            check_outputs(10'h3FF, 32'h000003FF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write to Invalid Address (Non-Zero)");
            reset_dut();

            address = 2'b00;
            writedata = 10'h155;
            chipselect = 1'b1;
            write_n = 1'b0;
            @(posedge clk);
            #2;

            address = 2'b01;
            writedata = 10'h2AA;
            write_n = 1'b0;
            @(posedge clk);
            #2;
            write_n = 1'b1;
            address = 2'b00;
            #1;

            check_outputs(10'h155, 32'h00000155);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write with Chipselect Inactive");
            reset_dut();
            address = 2'b00;
            writedata = 10'h123;
            chipselect = 1'b0;
            write_n = 1'b0;
            @(posedge clk);
            #2;
            write_n = 1'b1;
            chipselect = 1'b1;
            #1;

            check_outputs(10'h000, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Write with write_n High");
            reset_dut();
            address = 2'b00;
            writedata = 10'h123;
            chipselect = 1'b1;
            write_n = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h000, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Multiple Sequential Writes");
            reset_dut();
            address = 2'b00;
            chipselect = 1'b1;


            writedata = 10'h0AA;
            write_n = 1'b0;
            @(posedge clk);
            #2;


            writedata = 10'h255;
            write_n = 1'b0;
            @(posedge clk);
            #2;

            write_n = 1'b1;
            #1;

            check_outputs(10'h255, 32'h00000255);
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
        input [9:0] expected_out_port;
        input [31:0] expected_readdata;
        begin
            if (expected_out_port === (expected_out_port ^ out_port ^ expected_out_port) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: out_port=%h, readdata=%h",
                         out_port, readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_port=%h, readdata=%h",
                         expected_out_port, expected_readdata);
                $display("  Got:      out_port=%h, readdata=%h",
                         out_port, readdata);
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
        $dumpvars(0,address, chipselect, clk, reset_n, write_n, writedata, out_port, readdata);
    end

endmodule
