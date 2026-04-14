`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] AddrA;
    reg [2:0] AddrB;
    reg [2:0] AddrC;
    reg CEN;
    reg Clk;
    reg [7:0] DIH;
    reg [7:0] DIL;
    reg WEH;
    reg WEL;
    wire [7:0] DOAH;
    wire [7:0] DOAL;
    wire [7:0] DOBH;
    wire [7:0] DOBL;
    wire [7:0] DOCH;
    wire [7:0] DOCL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AddrA(AddrA),
        .AddrB(AddrB),
        .AddrC(AddrC),
        .CEN(CEN),
        .Clk(Clk),
        .DIH(DIH),
        .DIL(DIL),
        .WEH(WEH),
        .WEL(WEL),
        .DOAH(DOAH),
        .DOAL(DOAL),
        .DOBH(DOBH),
        .DOBL(DOBL),
        .DOCH(DOCH),
        .DOCL(DOCL)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            AddrA = 0;
            AddrB = 0;
            AddrC = 0;
            CEN = 0;
            DIH = 0;
            DIL = 0;
            WEH = 0;
            WEL = 0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            CEN = 1;
            WEH = 1;
            WEL = 1;
            AddrA = 3'd1;
            DIH = 8'hAA;
            DIL = 8'h55;
            @(posedge Clk);
            #1;


            WEH = 0;
            WEL = 0;
            AddrA = 3'd1;
            AddrB = 3'd1;
            AddrC = 3'd1;
            #1;

            #1;


            check_outputs(8'hAA, 8'h55, 8'hAA, 8'h55, 8'hAA, 8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            CEN = 1;
            WEH = 1;
            WEL = 0;
            AddrA = 3'd2;
            DIH = 8'hB1;
            DIL = 8'hFF;
            @(posedge Clk);
            #1;


            WEH = 0;
            WEL = 1;
            DIH = 8'hFF;
            DIL = 8'hB2;
            @(posedge Clk);
            #1;


            WEH = 0;
            WEL = 0;
            AddrA = 3'd2;
            AddrB = 3'd2;
            AddrC = 3'd2;
            #1;

            #1;


            check_outputs(8'hB1, 8'hB2, 8'hB1, 8'hB2, 8'hB1, 8'hB2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            CEN = 1;
            WEH = 1;
            WEL = 1;


            AddrA = 3'd5; DIH = 8'h55; DIL = 8'h5A;
            @(posedge Clk); #1;


            AddrA = 3'd6; DIH = 8'h66; DIL = 8'h6A;
            @(posedge Clk); #1;


            AddrA = 3'd7; DIH = 8'h77; DIL = 8'h7A;
            @(posedge Clk); #1;


            WEH = 0; WEL = 0;
            AddrA = 3'd5;
            AddrB = 3'd6;
            AddrC = 3'd7;
            #1;

            #1;


            check_outputs(8'h55, 8'h5A, 8'h66, 8'h6A, 8'h77, 8'h7A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            CEN = 0;
            WEH = 1;
            WEL = 1;
            AddrA = 3'd4;
            DIH = 8'hDD;
            DIL = 8'hEE;
            @(posedge Clk);
            #1;


            CEN = 1;
            WEH = 0;
            WEL = 0;
            AddrA = 3'd4;
            AddrB = 3'd4;
            AddrC = 3'd4;
            #1;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            CEN = 1; WEH = 1; WEL = 1;
            AddrA = 3'd0; DIH = 8'h11; DIL = 8'h22;
            @(posedge Clk); #1;


            DIH = 8'h99; DIL = 8'h88;
            @(posedge Clk); #1;

            WEH = 0; WEL = 0;
            AddrA = 3'd0; AddrB = 3'd0; AddrC = 3'd0;
            #1;

            #1;


            check_outputs(8'h99, 8'h88, 8'h99, 8'h88, 8'h99, 8'h88);
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
        input [7:0] expected_DOAH;
        input [7:0] expected_DOAL;
        input [7:0] expected_DOBH;
        input [7:0] expected_DOBL;
        input [7:0] expected_DOCH;
        input [7:0] expected_DOCL;
        begin
            if (expected_DOAH === (expected_DOAH ^ DOAH ^ expected_DOAH) &&
                expected_DOAL === (expected_DOAL ^ DOAL ^ expected_DOAL) &&
                expected_DOBH === (expected_DOBH ^ DOBH ^ expected_DOBH) &&
                expected_DOBL === (expected_DOBL ^ DOBL ^ expected_DOBL) &&
                expected_DOCH === (expected_DOCH ^ DOCH ^ expected_DOCH) &&
                expected_DOCL === (expected_DOCL ^ DOCL ^ expected_DOCL)) begin
                $display("PASS");
                $display("  Outputs: DOAH=%h, DOAL=%h, DOBH=%h, DOBL=%h, DOCH=%h, DOCL=%h",
                         DOAH, DOAL, DOBH, DOBL, DOCH, DOCL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOAH=%h, DOAL=%h, DOBH=%h, DOBL=%h, DOCH=%h, DOCL=%h",
                         expected_DOAH, expected_DOAL, expected_DOBH, expected_DOBL, expected_DOCH, expected_DOCL);
                $display("  Got:      DOAH=%h, DOAL=%h, DOBH=%h, DOBL=%h, DOCH=%h, DOCL=%h",
                         DOAH, DOAL, DOBH, DOBL, DOCH, DOCL);
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
        $dumpvars(0,AddrA, AddrB, AddrC, CEN, Clk, DIH, DIL, WEH, WEL, DOAH, DOAL, DOBH, DOBL, DOCH, DOCL);
    end

endmodule
