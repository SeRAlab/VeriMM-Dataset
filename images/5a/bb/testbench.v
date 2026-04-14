`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg chipselect;
    reg clk;
    reg reset_n;
    reg write_n;
    reg [31:0] writedata;
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
            write_n = 1;
            writedata = 0;
            tb_bidir_drive = 4'bz;
            @(posedge clk);
            #2 reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State Check");
            reset_dut();
            address = 2'b01;
            chipselect = 1;
            write_n = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Direction Register Write/Read");
            reset_dut();

            address = 2'b01;
            writedata = 32'h0000000F;
            chipselect = 1;
            write_n = 0;
            @(posedge clk);

            write_n = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000000F);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Output Mode Write/Read Data");
            reset_dut();

            address = 2'b01;
            writedata = 32'hF;
            chipselect = 1;
            write_n = 0;
            @(posedge clk);

            address = 2'b00;
            writedata = 32'h5;
            @(posedge clk);

            write_n = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Input Mode External Port Read");
            reset_dut();

            address = 2'b01;
            writedata = 32'h0;
            chipselect = 1;
            write_n = 0;
            @(posedge clk);

            tb_bidir_drive = 4'hA;

            address = 2'b00;
            write_n = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hA);
            tb_bidir_drive = 4'bz;
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Mixed Mode (Direction 0x3)");
            reset_dut();

            address = 2'b01;
            writedata = 32'h3;
            chipselect = 1;
            write_n = 0;
            @(posedge clk);

            address = 2'b00;
            writedata = 32'hF;
            @(posedge clk);

            tb_bidir_drive = 4'hC;

            write_n = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hF);
            tb_bidir_drive = 4'bz;
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
        input [31:0] expected_readdata;
        begin
            if (expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: readdata=%h",
                         readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readdata=%h",
                         expected_readdata);
                $display("  Got:      readdata=%h",
                         readdata);
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
        $dumpvars(0,address, chipselect, clk, reset_n, write_n, writedata, readdata);
    end

endmodule
