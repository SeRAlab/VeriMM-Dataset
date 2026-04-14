`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] RXD;
    reg RXD_START;
    reg TXD_DONE;
    wire MUX_SEL;
    wire [9:0] RAM_ADDR;
    wire [31:0] TRIG_DATA;
    wire TRIG_FORCE;
    wire TRIG_UPDATE;
    wire TXD_ENABLE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RXD(RXD),
        .RXD_START(RXD_START),
        .TXD_DONE(TXD_DONE),
        .MUX_SEL(MUX_SEL),
        .RAM_ADDR(RAM_ADDR),
        .TRIG_DATA(TRIG_DATA),
        .TRIG_FORCE(TRIG_FORCE),
        .TRIG_UPDATE(TRIG_UPDATE),
        .TXD_ENABLE(TXD_ENABLE)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RXD = 8'h00;
            RXD_START = 0;
            TXD_DONE = 0;
            repeat(5) @(posedge CLK);
        end
        endtask
    task send_byte;

        input [7:0] data;
        begin
            @(posedge CLK);
            #1;
            RXD = data;
            RXD_START = 1;
            @(posedge CLK);
            #1;
            RXD_START = 0;
            RXD = 8'h00;

            repeat(2) @(posedge CLK);
        end
        endtask

    task testcase001;

        begin
            $display("Running Testcase001: Set RAM_ADDR...");
            reset_dut();
            send_byte(8'h01);
            send_byte(8'h02);
            send_byte(8'h3F);
            repeat(2) @(posedge CLK);
            #1;

            check_outputs(1'bz, 10'h23F, 32'hzzzzzzzz, 1'bz, 1'bz, 1'bz);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase002: Set TRIG_DATA...");
            reset_dut();
            send_byte(8'h02);
            send_byte(8'hAA);
            send_byte(8'hBB);
            send_byte(8'hCC);
            send_byte(8'hDD);
            repeat(2) @(posedge CLK);
            #1;

            check_outputs(1'bz, 10'hzzz, 32'hAABBCCDD, 1'bz, 1'bz, 1'bz);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase003: Set MUX_SEL...");
            reset_dut();
            send_byte(8'h03);
            send_byte(8'h01);
            repeat(2) @(posedge CLK);
            #1;

            check_outputs(1'b1, 10'hzzz, 32'hzzzzzzzz, 1'bz, 1'bz, 1'bz);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase004: TRIG_UPDATE Pulse...");
            reset_dut();
            send_byte(8'h04);

            @(posedge CLK);
            #1;

            check_outputs(1'bz, 10'hzzz, 32'hzzzzzzzz, 1'bz, 1'b1, 1'bz);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase005: TRIG_FORCE Pulse...");
            reset_dut();
            send_byte(8'h05);
            @(posedge CLK);
            #1;

            check_outputs(1'bz, 10'hzzz, 32'hzzzzzzzz, 1'b1, 1'bz, 1'bz);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase006: TXD Handshake...");
            reset_dut();
            send_byte(8'h06);
            repeat(2) @(posedge CLK);

            if (TXD_ENABLE === 1'b1) begin
                $display("TXD_ENABLE successfully high.");
            end
            repeat(5) @(posedge CLK);
            TXD_DONE = 1;
            @(posedge CLK);
            TXD_DONE = 0;
            repeat(2) @(posedge CLK);
            #1;

            check_outputs(1'bz, 10'hzzz, 32'hzzzzzzzz, 1'bz, 1'bz, 1'b0);
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
        input expected_MUX_SEL;
        input [9:0] expected_RAM_ADDR;
        input [31:0] expected_TRIG_DATA;
        input expected_TRIG_FORCE;
        input expected_TRIG_UPDATE;
        input expected_TXD_ENABLE;
        begin
            if (expected_MUX_SEL === (expected_MUX_SEL ^ MUX_SEL ^ expected_MUX_SEL) &&
                expected_RAM_ADDR === (expected_RAM_ADDR ^ RAM_ADDR ^ expected_RAM_ADDR) &&
                expected_TRIG_DATA === (expected_TRIG_DATA ^ TRIG_DATA ^ expected_TRIG_DATA) &&
                expected_TRIG_FORCE === (expected_TRIG_FORCE ^ TRIG_FORCE ^ expected_TRIG_FORCE) &&
                expected_TRIG_UPDATE === (expected_TRIG_UPDATE ^ TRIG_UPDATE ^ expected_TRIG_UPDATE) &&
                expected_TXD_ENABLE === (expected_TXD_ENABLE ^ TXD_ENABLE ^ expected_TXD_ENABLE)) begin
                $display("PASS");
                $display("  Outputs: MUX_SEL=%b, RAM_ADDR=%h, TRIG_DATA=%h, TRIG_FORCE=%b, TRIG_UPDATE=%b, TXD_ENABLE=%b",
                         MUX_SEL, RAM_ADDR, TRIG_DATA, TRIG_FORCE, TRIG_UPDATE, TXD_ENABLE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MUX_SEL=%b, RAM_ADDR=%h, TRIG_DATA=%h, TRIG_FORCE=%b, TRIG_UPDATE=%b, TXD_ENABLE=%b",
                         expected_MUX_SEL, expected_RAM_ADDR, expected_TRIG_DATA, expected_TRIG_FORCE, expected_TRIG_UPDATE, expected_TXD_ENABLE);
                $display("  Got:      MUX_SEL=%b, RAM_ADDR=%h, TRIG_DATA=%h, TRIG_FORCE=%b, TRIG_UPDATE=%b, TXD_ENABLE=%b",
                         MUX_SEL, RAM_ADDR, TRIG_DATA, TRIG_FORCE, TRIG_UPDATE, TXD_ENABLE);
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
        $dumpvars(0,CLK, RXD, RXD_START, TXD_DONE, MUX_SEL, RAM_ADDR, TRIG_DATA, TRIG_FORCE, TRIG_UPDATE, TXD_ENABLE);
    end

endmodule
