`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] ADDR;
    reg CLK;
    reg READ;
    reg RST;
    reg WRITE;
    reg [1:0] WRITE_DATA;
    wire [1:0] READ_DATA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .CLK(CLK),
        .READ(READ),
        .RST(RST),
        .WRITE(WRITE),
        .WRITE_DATA(WRITE_DATA),
        .READ_DATA(READ_DATA)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            ADDR = 0;
            WRITE = 0;
            READ = 0;
            WRITE_DATA = 0;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Write/Read Reg0 (2-bit)");
            reset_dut();
            @(posedge CLK);
            #1 ADDR = 3'd0; WRITE_DATA = 2'b10; WRITE = 1;
            @(posedge CLK);
            #1 WRITE = 0; READ = 1; ADDR = 3'd0;
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write/Read Reg1 (1-bit)");
            reset_dut();
            @(posedge CLK);
            #1 ADDR = 3'd1; WRITE_DATA = 2'b01; WRITE = 1;
            @(posedge CLK);
            #1 WRITE = 0; READ = 1; ADDR = 3'd1;
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Reg1 Bit Truncation and Extension");
            reset_dut();
            @(posedge CLK);
            #1 ADDR = 3'd1; WRITE_DATA = 2'b11; WRITE = 1;
            @(posedge CLK);
            #1 WRITE = 0; READ = 1; ADDR = 3'd1;
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Reset Functionality");
            reset_dut();

            @(posedge CLK);
            #1 ADDR = 3'd0; WRITE_DATA = 2'b11; WRITE = 1;
            @(posedge CLK);
            #1 RST = 1;
            @(posedge CLK);
            #1 RST = 0; READ = 1; ADDR = 3'd0;
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: WRITE Signal Gating");
            reset_dut();
            @(posedge CLK);
            #1 ADDR = 3'd0; WRITE_DATA = 2'b11; WRITE = 0;
            @(posedge CLK);
            #1 READ = 1; ADDR = 3'd0;
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: READ Signal Gating");
            reset_dut();
            @(posedge CLK);
            #1 ADDR = 3'd0; WRITE_DATA = 2'b11; WRITE = 1;
            @(posedge CLK);
            #1 WRITE = 0; READ = 0; ADDR = 3'd0;
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Data Persistence and Multi-Address");
            reset_dut();

            @(posedge CLK);
            #1 ADDR = 3'd0; WRITE_DATA = 2'b11; WRITE = 1;
            @(posedge CLK);

            #1 ADDR = 3'd1; WRITE_DATA = 2'b01; WRITE = 1;
            @(posedge CLK);

            #1 WRITE = 0; READ = 1; ADDR = 3'd0;
            #2;
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_READ_DATA;
        begin
            if (expected_READ_DATA === (expected_READ_DATA ^ READ_DATA ^ expected_READ_DATA)) begin
                $display("PASS");
                $display("  Outputs: READ_DATA=%h",
                         READ_DATA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: READ_DATA=%h",
                         expected_READ_DATA);
                $display("  Got:      READ_DATA=%h",
                         READ_DATA);
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
        $dumpvars(0,ADDR, CLK, READ, RST, WRITE, WRITE_DATA, READ_DATA);
    end

endmodule
