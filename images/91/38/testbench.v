`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clock_in;
    reg memRead;
    reg memWrite;
    reg [31:0] writeData;
    wire [31:0] readData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock_in(clock_in),
        .memRead(memRead),
        .memWrite(memWrite),
        .writeData(writeData),
        .readData(readData)
    );

    // Clock generation (10ns period)
    initial begin
        clock_in = 0;
        forever #5 clock_in = ~clock_in;
    end

        task reset_dut;

        begin
            address = 32'h0;
            writeData = 32'h0;
            memWrite = 1'b0;
            memRead = 1'b0;
            @(posedge clock_in);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Read initialized word at address 0");
            reset_dut();
            address = 32'd0;
            memRead = 1'b1;
            @(posedge clock_in);
            #2;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Read initialized word at address 31");
            reset_dut();
            address = 32'd31;
            memRead = 1'b1;
            @(posedge clock_in);
            #2;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write 0xDEADBEEF to address 64 and read back");
            reset_dut();

            address = 32'd64;
            writeData = 32'hDEADBEEF;
            memWrite = 1'b1;
            @(posedge clock_in);
            #1;

            memWrite = 1'b0;
            memRead = 1'b1;
            @(posedge clock_in);
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write to boundary address 127");
            reset_dut();

            address = 32'd127;
            writeData = 32'h12345678;
            memWrite = 1'b1;
            @(posedge clock_in);
            #1;

            memWrite = 1'b0;
            memRead = 1'b1;
            @(posedge clock_in);
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Verify memWrite=0 prevents data update");
            reset_dut();

            address = 32'd10;
            writeData = 32'hAAAA_BBBB;
            memWrite = 1'b1;
            @(posedge clock_in);
            #1;

            writeData = 32'hFFFF_FFFF;
            memWrite = 1'b0;
            @(posedge clock_in);
            #1;

            memRead = 1'b1;
            @(posedge clock_in);
            #2;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Sequential multi-address access");
            reset_dut();

            address = 32'd5; writeData = 32'h1; memWrite = 1'b1;
            @(posedge clock_in); #1;

            address = 32'd6; writeData = 32'h2; memWrite = 1'b1;
            @(posedge clock_in); #1;

            memWrite = 1'b0;
            address = 32'd5; memRead = 1'b1;
            @(posedge clock_in); #2;
            #1;

            check_outputs(32'h1);
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
        input [31:0] expected_readData;
        begin
            if (expected_readData === (expected_readData ^ readData ^ expected_readData)) begin
                $display("PASS");
                $display("  Outputs: readData=%h",
                         readData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readData=%h",
                         expected_readData);
                $display("  Got:      readData=%h",
                         readData);
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
        $dumpvars(0,address, clock_in, memRead, memWrite, writeData, readData);
    end

endmodule
