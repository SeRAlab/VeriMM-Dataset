`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg chipselect;
    reg clk;
    reg reset_n;
    reg write_n;
    reg [7:0] writedata;
    wire [7:0] out_port;
    wire [7:0] readdata;

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
            writedata = 8'h00;
            #20;
            reset_n = 1'b1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset state check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic write to address 0", test_num);
            reset_dut();

            @(posedge clk);
            address = 2'b00;
            chipselect = 1'b1;
            write_n = 1'b0;
            writedata = 8'hAA;

            @(posedge clk);
            #1;


            write_n = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Write 0x55 to address 0", test_num);
            reset_dut();

            @(posedge clk);
            address = 2'b00;
            chipselect = 1'b1;
            write_n = 1'b0;
            writedata = 8'h55;

            @(posedge clk);
            #1;
            write_n = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Chipselect disabled write", test_num);
            reset_dut();


            @(posedge clk);
            address = 2'b00;
            chipselect = 1'b1;
            write_n = 1'b0;
            writedata = 8'hAA;
            @(posedge clk);


            @(posedge clk);
            chipselect = 1'b0;
            write_n = 1'b0;
            writedata = 8'hBB;
            @(posedge clk);


            #1;
            chipselect = 1'b1;
            write_n = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA, 8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: write_n disabled (read mode) during data drive", test_num);
            reset_dut();


            @(posedge clk);
            address = 2'b00;
            chipselect = 1'b1;
            write_n = 1'b0;
            writedata = 8'hCC;
            @(posedge clk);


            @(posedge clk);
            chipselect = 1'b1;
            write_n = 1'b1;
            writedata = 8'hDD;
            @(posedge clk);


            #1;
            #1;

            check_outputs(8'hCC, 8'hCC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multiple address access", test_num);
            reset_dut();


            @(posedge clk);
            address = 2'b00;
            chipselect = 1'b1;
            write_n = 1'b0;
            writedata = 8'h11;
            @(posedge clk);


            write_n = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h11, 8'h11);
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
        input [7:0] expected_out_port;
        input [7:0] expected_readdata;
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
