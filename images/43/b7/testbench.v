`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg chipselect;
    reg clk;
    reg reset_n;
    reg write_n;
    reg [31:0] writedata;
    wire [14:0] out_port;
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
            address = 2'b00;
            chipselect = 1'b0;
            write_n = 1'b1;
            writedata = 32'h0;
            reset_n = 1'b0;
            repeat(2) @(posedge clk);
            #1;
            reset_n = 1'b1;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: Reset Check");
            reset_dut();

            address = 2'b00;
            chipselect = 1'b1;
            #2;
            #1;

            check_outputs(15'h0000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Write and Read Address 0");
            reset_dut();


            @(posedge clk);
            #1;
            address = 2'b00;
            chipselect = 1'b1;
            write_n = 1'b0;
            writedata = 32'hAAAA5555;

            @(posedge clk);
            #1;
            write_n = 1'b1;



            #1;




            check_outputs(15'h5555, 32'hAAAA5555);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Write ignore when Chipselect is low");
            reset_dut();


            @(posedge clk);
            #1;
            address = 2'b00; chipselect = 1'b1; write_n = 1'b0; writedata = 32'h12345678;
            @(posedge clk);
            #1;


            chipselect = 1'b0; write_n = 1'b0; writedata = 32'hFFFFFFFF;
            @(posedge clk);
            #1;


            chipselect = 1'b1; write_n = 1'b1; address = 2'b00;
            #2;
            #1;

            check_outputs(15'h5678, 32'h12345678);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Write ignore when Address != 0");
            reset_dut();


            @(posedge clk);
            #1;
            address = 2'b00; chipselect = 1'b1; write_n = 1'b0; writedata = 32'h77778888;
            @(posedge clk);
            #1;


            address = 2'b01; chipselect = 1'b1; write_n = 1'b0; writedata = 32'h00000000;
            @(posedge clk);
            #1;


            address = 2'b00; write_n = 1'b1;
            #2;
            #1;

            check_outputs(15'h0888, 32'h77778888);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Read address selection check");
            reset_dut();


            @(posedge clk);
            #1;
            address = 2'b00; chipselect = 1'b1; write_n = 1'b0; writedata = 32'hDEADC0DE;
            @(posedge clk);
            #1;


            address = 2'b01;
            write_n = 1'b1;
            #2;



            address = 2'b00;
            #2;
            #1;

            check_outputs(15'h40DE, 32'hDEADC0DE);
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
        input [14:0] expected_out_port;
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
