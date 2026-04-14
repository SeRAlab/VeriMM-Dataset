`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] BUS_ADDR;
    reg BUS_WE;
    reg CLK;
    reg RST;
    reg [7:0] SWITCH_VALUE;
    wire [7:0] BUS_DATA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .CLK(CLK),
        .RST(RST),
        .SWITCH_VALUE(SWITCH_VALUE),
        .BUS_DATA(BUS_DATA)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            BUS_WE = 0;
            BUS_ADDR = 8'h00;
            SWITCH_VALUE = 8'h00;
            @(posedge CLK);
            #2;
            RST = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            BUS_ADDR = 8'h80;
            BUS_WE = 0;
            #10;
            $display("Testcase 001: Reset state at 0x80");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            BUS_ADDR = 8'h80;
            BUS_WE = 1;
            SWITCH_VALUE = 8'hA5;
            @(posedge CLK);
            #5;
            $display("Testcase 002: Successful write 0xA5 to 0x80");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            BUS_ADDR = 8'h7F;
            BUS_WE = 0;
            #10;
            $display("Testcase 003: High-Z at non-matching address 0x7F");
            #1;

            check_outputs(8'hzz);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            BUS_ADDR = 8'h20;
            BUS_WE = 1;
            SWITCH_VALUE = 8'hFF;
            @(posedge CLK);
            #5;

            BUS_ADDR = 8'h80;
            BUS_WE = 0;
            #10;
            $display("Testcase 004: Prevent write to 0x80 when address mismatch (at 0x20)");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            BUS_ADDR = 8'h80;
            BUS_WE = 0;
            SWITCH_VALUE = 8'h55;
            @(posedge CLK);
            #5;
            $display("Testcase 005: Prevent write to 0x80 when WE=0");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            BUS_ADDR = 8'h80;
            BUS_WE = 1;
            SWITCH_VALUE = 8'h3C;
            @(posedge CLK);
            #5;

            BUS_WE = 0;
            SWITCH_VALUE = 8'hAA;
            @(posedge CLK);
            #5;
            $display("Testcase 006: Data persistence at 0x80 when WE=0 and Switch changes");
            #1;

            check_outputs(8'h3C);
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
        input [7:0] expected_BUS_DATA;
        begin
            if (expected_BUS_DATA === (expected_BUS_DATA ^ BUS_DATA ^ expected_BUS_DATA)) begin
                $display("PASS");
                $display("  Outputs: BUS_DATA=%h",
                         BUS_DATA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BUS_DATA=%h",
                         expected_BUS_DATA);
                $display("  Got:      BUS_DATA=%h",
                         BUS_DATA);
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
        $dumpvars(0,BUS_ADDR, BUS_WE, CLK, RST, SWITCH_VALUE, BUS_DATA);
    end

endmodule
