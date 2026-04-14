`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg chipselect;
    reg clk;
    reg reset_n;
    reg write_n;
    reg [31:0] writedata;
    wire [3:0] out_port;
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
            address = 2'b0;
            chipselect = 1'b0;
            write_n = 1'b1;
            writedata = 32'b0;
            repeat (2) @(posedge clk);
            #1 reset_n = 1'b1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();

            chipselect = 1;
            address = 0;
            #1 #1;
 check_outputs(4'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Write/Read");
            reset_dut();
            @(posedge clk);
            address = 2'b00;
            chipselect = 1'b1;
            write_n = 1'b0;
            writedata = 32'h0000_000A;
            @(posedge clk);
            #1 write_n = 1'b1;
            #1;

            check_outputs(4'hA, 32'h0000_000A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Chipselect Gating");
            reset_dut();

            address = 0; chipselect = 1; write_n = 0; writedata = 32'h5;
            @(posedge clk);

            #1 chipselect = 0; write_n = 0; writedata = 32'hF;
            @(posedge clk);

            #1 chipselect = 1;
            #1;

            check_outputs(4'h5, 32'h0000_0005);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: write_n Gating");
            reset_dut();
            address = 0; chipselect = 1; write_n = 1; writedata = 32'hF;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Address Decoding");
            reset_dut();
            address = 2'b01; chipselect = 1; write_n = 0; writedata = 32'h7;
            @(posedge clk);
            #1 address = 0;
            #1;

            check_outputs(4'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Bit Masking (Lower 4 bits)");
            reset_dut();
            address = 0; chipselect = 1; write_n = 0; writedata = 32'hFFFF_FFF3;
            @(posedge clk);
            #1 write_n = 1;
            #1;

            check_outputs(4'h3, 32'h0000_0003);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Sequential Updates");
            reset_dut();
            address = 0; chipselect = 1; write_n = 0;
            writedata = 32'h1; @(posedge clk);
            #1 writedata = 32'h2; @(posedge clk);
            #1 writedata = 32'h4; @(posedge clk);
            #1 writedata = 32'h8; @(posedge clk);
            #1 write_n = 1;
            #1;

            check_outputs(4'h8, 32'h0000_0008);
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
        testcase007();
        
        
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
        input [3:0] expected_out_port;
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
