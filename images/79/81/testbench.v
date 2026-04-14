`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] InsTag_Special;
    reg NatLogFlagout_Special;
    reg [32:0] aout_Special;
    reg [32:0] bout_Special;
    reg clock;
    reg [35:0] cout_Special;
    reg [1:0] idle_Special;
    reg [1:0] modeout_Special;
    reg operationout_Special;
    reg [31:0] sout_Special;
    reg [35:0] zout_Special;
    wire [7:0] InsTag_Multiply;
    wire NatLogFlagout_Multiply;
    wire [35:0] cout_Multiply;
    wire [1:0] idle_Multiply;
    wire [1:0] modeout_Multiply;
    wire operationout_Multiply;
    wire [49:0] productout_Multiply;
    wire [31:0] sout_Multiply;
    wire [35:0] zout_Multiply;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .InsTag_Special(InsTag_Special),
        .NatLogFlagout_Special(NatLogFlagout_Special),
        .aout_Special(aout_Special),
        .bout_Special(bout_Special),
        .clock(clock),
        .cout_Special(cout_Special),
        .idle_Special(idle_Special),
        .modeout_Special(modeout_Special),
        .operationout_Special(operationout_Special),
        .sout_Special(sout_Special),
        .zout_Special(zout_Special),
        .InsTag_Multiply(InsTag_Multiply),
        .NatLogFlagout_Multiply(NatLogFlagout_Multiply),
        .cout_Multiply(cout_Multiply),
        .idle_Multiply(idle_Multiply),
        .modeout_Multiply(modeout_Multiply),
        .operationout_Multiply(operationout_Multiply),
        .productout_Multiply(productout_Multiply),
        .sout_Multiply(sout_Multiply),
        .zout_Multiply(zout_Multiply)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        InsTag_Special = 0;
        NatLogFlagout_Special = 0;
        aout_Special = 0;
        bout_Special = 0;
        cout_Special = 0;
        idle_Special = 0;
        modeout_Special = 0;
        operationout_Special = 0;
        sout_Special = 0;
        zout_Special = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        aout_Special = 33'h00000000A;
        bout_Special = 33'h000000014;
        InsTag_Special = 8'h01;
        @(posedge clock);
        #1;
        #1;

        check_outputs(8'h01, 0, 36'h0, 2'h0, 2'h0, 0, 50'h00000000000C8, 32'h0, 36'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        aout_Special = 33'h000010000;
        bout_Special = 33'h000010000;
        InsTag_Special = 8'hAA;
        NatLogFlagout_Special = 1;
        modeout_Special = 2'b11;
        idle_Special = 2'b01;
        cout_Special = 36'hFEDCBA987;
        @(posedge clock);
        #1;
        #1;

        check_outputs(8'hAA, 1, 36'hFEDCBA987, 2'b01, 2'b11, 0, 50'h00000100000000, 32'h0, 36'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        aout_Special = 33'h1FFFFFFFF;
        bout_Special = 33'h0;
        InsTag_Special = 8'h55;
        @(posedge clock);
        #1;
        #1;

        check_outputs(8'h55, 0, 36'h0, 2'h0, 2'h0, 0, 50'h0, 32'h0, 36'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        aout_Special = 33'h1FFFFFFFF;
        bout_Special = 33'h1FFFFFFFF;
        sout_Special = 32'hA5A5A5A5;
        zout_Special = 36'h76543210F;
        operationout_Special = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(8'h00, 0, 36'h0, 2'h0, 2'h0, 1, 50'h3FFFC00000001, 32'hA5A5A5A5, 36'h76543210F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        aout_Special = 33'h100000000;
        bout_Special = 33'h000000004;
        @(posedge clock);
        #1;

        #1;


        check_outputs(8'h00, 0, 36'h0, 2'h0, 2'h0, 0, 50'h0000400000000, 32'h0, 36'h0);
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
        input [7:0] expected_InsTag_Multiply;
        input expected_NatLogFlagout_Multiply;
        input [35:0] expected_cout_Multiply;
        input [1:0] expected_idle_Multiply;
        input [1:0] expected_modeout_Multiply;
        input expected_operationout_Multiply;
        input [49:0] expected_productout_Multiply;
        input [31:0] expected_sout_Multiply;
        input [35:0] expected_zout_Multiply;
        begin
            if (expected_InsTag_Multiply === (expected_InsTag_Multiply ^ InsTag_Multiply ^ expected_InsTag_Multiply) &&
                expected_NatLogFlagout_Multiply === (expected_NatLogFlagout_Multiply ^ NatLogFlagout_Multiply ^ expected_NatLogFlagout_Multiply) &&
                expected_cout_Multiply === (expected_cout_Multiply ^ cout_Multiply ^ expected_cout_Multiply) &&
                expected_idle_Multiply === (expected_idle_Multiply ^ idle_Multiply ^ expected_idle_Multiply) &&
                expected_modeout_Multiply === (expected_modeout_Multiply ^ modeout_Multiply ^ expected_modeout_Multiply) &&
                expected_operationout_Multiply === (expected_operationout_Multiply ^ operationout_Multiply ^ expected_operationout_Multiply) &&
                expected_productout_Multiply === (expected_productout_Multiply ^ productout_Multiply ^ expected_productout_Multiply) &&
                expected_sout_Multiply === (expected_sout_Multiply ^ sout_Multiply ^ expected_sout_Multiply) &&
                expected_zout_Multiply === (expected_zout_Multiply ^ zout_Multiply ^ expected_zout_Multiply)) begin
                $display("PASS");
                $display("  Outputs: InsTag_Multiply=%h, NatLogFlagout_Multiply=%b, cout_Multiply=%h, idle_Multiply=%h, modeout_Multiply=%h, operationout_Multiply=%b, productout_Multiply=%h, sout_Multiply=%h, zout_Multiply=%h",
                         InsTag_Multiply, NatLogFlagout_Multiply, cout_Multiply, idle_Multiply, modeout_Multiply, operationout_Multiply, productout_Multiply, sout_Multiply, zout_Multiply);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: InsTag_Multiply=%h, NatLogFlagout_Multiply=%b, cout_Multiply=%h, idle_Multiply=%h, modeout_Multiply=%h, operationout_Multiply=%b, productout_Multiply=%h, sout_Multiply=%h, zout_Multiply=%h",
                         expected_InsTag_Multiply, expected_NatLogFlagout_Multiply, expected_cout_Multiply, expected_idle_Multiply, expected_modeout_Multiply, expected_operationout_Multiply, expected_productout_Multiply, expected_sout_Multiply, expected_zout_Multiply);
                $display("  Got:      InsTag_Multiply=%h, NatLogFlagout_Multiply=%b, cout_Multiply=%h, idle_Multiply=%h, modeout_Multiply=%h, operationout_Multiply=%b, productout_Multiply=%h, sout_Multiply=%h, zout_Multiply=%h",
                         InsTag_Multiply, NatLogFlagout_Multiply, cout_Multiply, idle_Multiply, modeout_Multiply, operationout_Multiply, productout_Multiply, sout_Multiply, zout_Multiply);
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
        $dumpvars(0,InsTag_Special, NatLogFlagout_Special, aout_Special, bout_Special, clock, cout_Special, idle_Special, modeout_Special, operationout_Special, sout_Special, zout_Special, InsTag_Multiply, NatLogFlagout_Multiply, cout_Multiply, idle_Multiply, modeout_Multiply, operationout_Multiply, productout_Multiply, sout_Multiply, zout_Multiply);
    end

endmodule
