`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg C383;
    reg CLK;
    reg [31:0] DI;
    reg [31:0] DR;
    reg DS;
    reg ED;
    reg MPYJ;
    wire [31:0] DOI;
    wire [31:0] DOR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C383(C383),
        .CLK(CLK),
        .DI(DI),
        .DR(DR),
        .DS(DS),
        .ED(ED),
        .MPYJ(MPYJ),
        .DOI(DOI),
        .DOR(DOR)
    );

        task reset_dut;

        begin
            @(posedge CLK);
            C383 = 0;
            DI = 0;
            DR = 0;
            DS = 0;
            ED = 0;
            MPYJ = 0;
            repeat(2) @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic Processing (ED=1, others 0)", test_num);
            DR = 32'h0000_000A;
            DI = 32'h0000_0005;
            ED = 1;
            DS = 0;
            MPYJ = 0;
            C383 = 0;
            repeat(1) @(posedge CLK);
            #1;


            #1;



            check_outputs(32'h0000_0005, 32'h0000_000A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: DS Signal Influence", test_num);
            DR = 32'h0000_0100;
            DI = 32'h0000_0200;
            ED = 1;
            DS = 1;
            MPYJ = 0;
            C383 = 0;
            repeat(1) @(posedge CLK);
            #1;
            #1;

            check_outputs(32'h0000_0200, 32'h0000_0100);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: MPYJ Control (Imaginary Unit Logic)", test_num);
            DR = 32'h0000_0010;
            DI = 32'h0000_0020;
            ED = 1;
            DS = 0;
            MPYJ = 1;
            C383 = 0;
            repeat(1) @(posedge CLK);
            #1;

            #1;


            check_outputs(32'h0000_0010, 32'hFFFF_FFE0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: C383 Mode Selection", test_num);
            DR = 32'h0000_1234;
            DI = 32'h0000_5678;
            ED = 1;
            DS = 0;
            MPYJ = 0;
            C383 = 1;
            repeat(1) @(posedge CLK);
            #1;
            #1;

            check_outputs(32'h0000_5678, 32'h0000_1234);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Enable Signal (ED=0)", test_num);
            DR = 32'hFFFF_FFFF;
            DI = 32'hAAAA_BBBB;
            ED = 0;
            DS = 0;
            MPYJ = 0;
            C383 = 0;
            repeat(1) @(posedge CLK);
            #1;

            #1;


            check_outputs(32'h0000_0000, 32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Maximum Signed Values", test_num);
            DR = 32'h7FFF_FFFF;
            DI = 32'h7FFF_FFFF;
            ED = 1;
            DS = 0;
            MPYJ = 0;
            C383 = 0;
            repeat(1) @(posedge CLK);
            #1;
            #1;

            check_outputs(32'h7FFF_FFFF, 32'h7FFF_FFFF);
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
        input [31:0] expected_DOI;
        input [31:0] expected_DOR;
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
        $dumpvars(0,C383, CLK, DI, DR, DS, ED, MPYJ, DOI, DOR);
    end

endmodule
