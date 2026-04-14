`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] DI;
    reg [31:0] DR;
    reg DS;
    reg ED;
    reg MPYJ;
    wire [32:0] DOI;
    wire [32:0] DOR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DI(DI),
        .DR(DR),
        .DS(DS),
        .ED(ED),
        .MPYJ(MPYJ),
        .DOI(DOI),
        .DOR(DOR)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            DS = 1;
            ED = 0;
            MPYJ = 0;
            DR = 0;
            DI = 0;
            @(posedge CLK);
            #1;
            DS = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(negedge CLK);
            DR = {16'h0001, 16'h0001};
            DI = {16'h0000, 16'h0000};
            ED = 1;
            MPYJ = 0;
            @(posedge CLK);
            #2;
            $display("Testcase 001: (1+0j)*(1+0j)");
            #1;

            check_outputs(33'h000000000, 33'h000000001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge CLK);
            DR = {16'h0000, 16'h0000};
            DI = {16'h0001, 16'h0001};
            ED = 1;
            MPYJ = 0;
            @(posedge CLK);
            #2;
            $display("Testcase 002: (0+1j)*(0+1j)");
            #1;

            check_outputs(33'h000000000, 33'h1FFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge CLK);
            DR = {16'h0001, 16'h0003};
            DI = {16'h0002, 16'h0004};
            ED = 1;
            MPYJ = 0;
            @(posedge CLK);
            #2;
            $display("Testcase 003: (1+2j)*(3+4j)");
            #1;

            check_outputs(33'h00000000A, 33'h1FFFFFFFB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge CLK);
            DR = {16'h0001, 16'h0003};
            DI = {16'h0002, 16'h0004};
            ED = 1;
            MPYJ = 1;
            @(posedge CLK);
            #2;
            $display("Testcase 004: (1+2j)*(3+4j) * j");
            #1;

            check_outputs(33'h1FFFFFFFB, 33'h1FFFFFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge CLK);
            DR = {16'hFFFF, 16'h0002};
            DI = {16'hFFFF, 16'h0002};
            ED = 1;
            MPYJ = 0;
            @(posedge CLK);
            #2;
            $display("Testcase 005: (-1-1j)*(2+2j)");
            #1;

            check_outputs(33'h1FFFFFFFC, 33'h000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge CLK);
            DR = {16'h7530, 16'h7530};
            DI = {16'h0000, 16'h0000};
            ED = 1;
            MPYJ = 0;
            @(posedge CLK);
            #2;
            $display("Testcase 006: Large numbers (30000*30000)");
            #1;

            check_outputs(33'h000000000, 33'h035A4E900);
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
        input [32:0] expected_DOI;
        input [32:0] expected_DOR;
        begin
            if (expected_DOI === (expected_DOI ^ DOI ^ expected_DOI) &&
                expected_DOR === (expected_DOR ^ DOR ^ expected_DOR)) begin
                $display("PASS");
                $display("  Outputs: DOI=%h, DOR=%h",
                         DOI, DOR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOI=%h, DOR=%h",
                         expected_DOI, expected_DOR);
                $display("  Got:      DOI=%h, DOR=%h",
                         DOI, DOR);
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
        $dumpvars(0,CLK, DI, DR, DS, ED, MPYJ, DOI, DOR);
    end

endmodule
