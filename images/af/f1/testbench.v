`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] ADDR;
    reg CLK;
    reg [7:0] DIN;
    reg DINP;
    reg EN;
    reg WE;
    wire [7:0] DOUT;
    wire DOUTP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .CLK(CLK),
        .DIN(DIN),
        .DINP(DINP),
        .EN(EN),
        .WE(WE),
        .DOUT(DOUT),
        .DOUTP(DOUTP)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            ADDR = 0;
            DIN = 0;
            DINP = 0;
            EN = 0;
            WE = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Bank 0 Write/Read");
            reset_dut();

            ADDR = 13'h0055;
            DIN = 8'hAA;
            DINP = 1;
            EN = 1;
            WE = 1;
            @(posedge CLK);
            #1;

            WE = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'hAA, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Bank 1 Write/Read");
            reset_dut();

            ADDR = 13'h08A0;
            DIN = 8'h33;
            DINP = 0;
            EN = 1;
            WE = 1;
            @(posedge CLK);
            #1;

            WE = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'h33, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Bank 2 Write/Read");
            reset_dut();

            ADDR = 13'h1111;
            DIN = 8'h55;
            DINP = 1;
            EN = 1;
            WE = 1;
            @(posedge CLK);
            #1;

            WE = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'h55, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: EN signal check (Writing while disabled)");
            reset_dut();

            ADDR = 13'h0100;
            DIN = 8'hBE;
            DINP = 1;
            EN = 1;
            WE = 1;
            @(posedge CLK);
            #1;

            DIN = 8'hEF;
            DINP = 0;
            EN = 0;
            WE = 1;
            @(posedge CLK);
            #1;

            EN = 1;
            WE = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'hBE, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: WE signal check (Writing while WE is low)");
            reset_dut();

            ADDR = 13'h0200;
            DIN = 8'hCC;
            DINP = 0;
            EN = 1;
            WE = 1;
            @(posedge CLK);
            #1;

            DIN = 8'hDD;
            DINP = 1;
            WE = 0;
            @(posedge CLK);
            #1;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'hCC, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Bank 2 upper boundary check");
            reset_dut();
            ADDR = 13'h17FF;
            DIN = 8'hFF;
            DINP = 1;
            EN = 1;
            WE = 1;
            @(posedge CLK);
            #1;
            WE = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'hFF, 1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Rapid bank switching");
            reset_dut();

            ADDR = 13'h0001; DIN = 8'h01; EN = 1; WE = 1; @(posedge CLK); #1;

            ADDR = 13'h0801; DIN = 8'h02; EN = 1; WE = 1; @(posedge CLK); #1;


            ADDR = 13'h0001; WE = 0; @(posedge CLK); #2;
            if (DOUT !== 8'h01) $display("Fail step 1");


            ADDR = 13'h0801; @(posedge CLK); #2;
            #1;

            check_outputs(8'h02, 0);
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
        input [7:0] expected_DOUT;
        input expected_DOUTP;
        begin
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT) &&
                expected_DOUTP === (expected_DOUTP ^ DOUTP ^ expected_DOUTP)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h, DOUTP=%b",
                         DOUT, DOUTP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h, DOUTP=%b",
                         expected_DOUT, expected_DOUTP);
                $display("  Got:      DOUT=%h, DOUTP=%b",
                         DOUT, DOUTP);
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
        $dumpvars(0,ADDR, CLK, DIN, DINP, EN, WE, DOUT, DOUTP);
    end

endmodule
