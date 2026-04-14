`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg OTG_INT0;
    reg OTG_INT1;
    reg [1:0] iADDR;
    reg iCLK;
    reg iCS_N;
    reg [15:0] iDATA;
    reg iRD_N;
    reg iRST_N;
    reg iWR_N;
    wire [1:0] OTG_ADDR;
    wire OTG_CS_N;
    wire OTG_RD_N;
    wire OTG_RST_N;
    wire OTG_WR_N;
    wire [15:0] oDATA;
    wire oINT0_N;
    wire oINT1_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .OTG_INT0(OTG_INT0),
        .OTG_INT1(OTG_INT1),
        .iADDR(iADDR),
        .iCLK(iCLK),
        .iCS_N(iCS_N),
        .iDATA(iDATA),
        .iRD_N(iRD_N),
        .iRST_N(iRST_N),
        .iWR_N(iWR_N),
        .OTG_ADDR(OTG_ADDR),
        .OTG_CS_N(OTG_CS_N),
        .OTG_RD_N(OTG_RD_N),
        .OTG_RST_N(OTG_RST_N),
        .OTG_WR_N(OTG_WR_N),
        .oDATA(oDATA),
        .oINT0_N(oINT0_N),
        .oINT1_N(oINT1_N)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            iRST_N = 0;
            iCS_N = 1;
            iRD_N = 1;
            iWR_N = 1;
            iADDR = 2'b00;
            iDATA = 16'h0000;
            OTG_INT0 = 0;
            OTG_INT1 = 0;
            repeat(2) @(posedge iCLK);
            iRST_N = 1;
            @(posedge iCLK);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Idle State Check");
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b1, 1'b1, 1'b1, 1'b1, 16'h0000, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Read Cycle Address 1");
            reset_dut();
            iADDR = 2'b01;
            iCS_N = 0;
            iRD_N = 0;
            iWR_N = 1;
            @(posedge iCLK);
            #1;

            check_outputs(2'b01, 1'b0, 1'b0, 1'b1, 1'b1, 16'h0000, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Cycle Address 2");
            reset_dut();
            iADDR = 2'b10;
            iDATA = 16'hA5A5;
            iCS_N = 0;
            iRD_N = 1;
            iWR_N = 0;
            @(posedge iCLK);
            #1;

            check_outputs(2'b10, 1'b0, 1'b1, 1'b1, 1'b0, 16'hA5A5, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Interrupt 0 Inversion");
            reset_dut();
            OTG_INT0 = 1;
            @(posedge iCLK);

            #1;


            check_outputs(2'b00, 1'b1, 1'b1, 1'b1, 1'b1, 16'h0000, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Interrupt 1 Inversion");
            reset_dut();
            OTG_INT1 = 1;
            @(posedge iCLK);

            #1;


            check_outputs(2'b00, 1'b1, 1'b1, 1'b1, 1'b1, 16'h0000, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset Propagation");
            reset_dut();
            iRST_N = 0;
            @(posedge iCLK);
            #1;

            check_outputs(2'b00, 1'b1, 1'b1, 1'b0, 1'b1, 16'h0000, 1'b1, 1'b1);
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
        input [1:0] expected_OTG_ADDR;
        input expected_OTG_CS_N;
        input expected_OTG_RD_N;
        input expected_OTG_RST_N;
        input expected_OTG_WR_N;
        input [15:0] expected_oDATA;
        input expected_oINT0_N;
        input expected_oINT1_N;
        begin
            if (expected_OTG_ADDR === (expected_OTG_ADDR ^ OTG_ADDR ^ expected_OTG_ADDR) &&
                expected_OTG_CS_N === (expected_OTG_CS_N ^ OTG_CS_N ^ expected_OTG_CS_N) &&
                expected_OTG_RD_N === (expected_OTG_RD_N ^ OTG_RD_N ^ expected_OTG_RD_N) &&
                expected_OTG_RST_N === (expected_OTG_RST_N ^ OTG_RST_N ^ expected_OTG_RST_N) &&
                expected_OTG_WR_N === (expected_OTG_WR_N ^ OTG_WR_N ^ expected_OTG_WR_N) &&
                expected_oDATA === (expected_oDATA ^ oDATA ^ expected_oDATA) &&
                expected_oINT0_N === (expected_oINT0_N ^ oINT0_N ^ expected_oINT0_N) &&
                expected_oINT1_N === (expected_oINT1_N ^ oINT1_N ^ expected_oINT1_N)) begin
                $display("PASS");
                $display("  Outputs: OTG_ADDR=%h, OTG_CS_N=%b, OTG_RD_N=%b, OTG_RST_N=%b, OTG_WR_N=%b, oDATA=%h, oINT0_N=%b, oINT1_N=%b",
                         OTG_ADDR, OTG_CS_N, OTG_RD_N, OTG_RST_N, OTG_WR_N, oDATA, oINT0_N, oINT1_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OTG_ADDR=%h, OTG_CS_N=%b, OTG_RD_N=%b, OTG_RST_N=%b, OTG_WR_N=%b, oDATA=%h, oINT0_N=%b, oINT1_N=%b",
                         expected_OTG_ADDR, expected_OTG_CS_N, expected_OTG_RD_N, expected_OTG_RST_N, expected_OTG_WR_N, expected_oDATA, expected_oINT0_N, expected_oINT1_N);
                $display("  Got:      OTG_ADDR=%h, OTG_CS_N=%b, OTG_RD_N=%b, OTG_RST_N=%b, OTG_WR_N=%b, oDATA=%h, oINT0_N=%b, oINT1_N=%b",
                         OTG_ADDR, OTG_CS_N, OTG_RD_N, OTG_RST_N, OTG_WR_N, oDATA, oINT0_N, oINT1_N);
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
        $dumpvars(0,OTG_INT0, OTG_INT1, iADDR, iCLK, iCS_N, iDATA, iRD_N, iRST_N, iWR_N, OTG_ADDR, OTG_CS_N, OTG_RD_N, OTG_RST_N, OTG_WR_N, oDATA, oINT0_N, oINT1_N);
    end

endmodule
