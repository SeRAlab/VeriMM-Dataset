`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] ADDR;
    reg CLK;
    reg [35:0] DATAIN;
    reg OE;
    reg WE;
    wire [35:0] DATAOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .CLK(CLK),
        .DATAIN(DATAIN),
        .OE(OE),
        .WE(WE),
        .DATAOUT(DATAOUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            ADDR = 10'd0;
            DATAIN = 36'd0;
            WE = 0;
            OE = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read...");
            reset_dut();
            test_num = 1;


            @(posedge CLK);
            ADDR = 10'h0A5;
            DATAIN = 36'h123456789;
            WE = 1;
            OE = 0;

            @(posedge CLK);
            WE = 0;


            ADDR = 10'h0A5;
            OE = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(36'h123456789);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Max Address Access...");
            reset_dut();
            test_num = 2;

            @(posedge CLK);
            ADDR = 10'h3FF;
            DATAIN = 36'hF_FFFF_FFFF;
            WE = 1;
            OE = 0;

            @(posedge CLK);
            WE = 0;
            ADDR = 10'h3FF;
            OE = 1;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(36'hF_FFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: WE Inhibit Check...");
            reset_dut();
            test_num = 3;


            @(posedge CLK);
            ADDR = 10'h010;
            DATAIN = 36'hA_AAAA_AAAA;
            WE = 1;

            @(posedge CLK);

            WE = 0;
            DATAIN = 36'h5_5555_5555;

            @(posedge CLK);

            OE = 1;
            ADDR = 10'h010;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(36'hA_AAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Multiple Address Integrity...");
            reset_dut();
            test_num = 4;


            @(posedge CLK);
            ADDR = 10'h001; DATAIN = 36'hB_BBBB_BBBB; WE = 1;
            @(posedge CLK);

            ADDR = 10'h002; DATAIN = 36'hC_CCCC_CCCC; WE = 1;
            @(posedge CLK);
            WE = 0;

            ADDR = 10'h001; OE = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(36'hB_BBBB_BBBB);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: OE Control Check...");
            reset_dut();
            test_num = 5;


            @(posedge CLK);
            ADDR = 10'h055;
            DATAIN = 36'hD_DDDD_DDDD;
            WE = 1;

            @(posedge CLK);
            WE = 0;
            OE = 0;
            ADDR = 10'h055;

            @(posedge CLK);
            #2;


            OE = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(36'hD_DDDD_DDDD);
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
        input [35:0] expected_DATAOUT;
        begin
            if (expected_DATAOUT === (expected_DATAOUT ^ DATAOUT ^ expected_DATAOUT)) begin
                $display("PASS");
                $display("  Outputs: DATAOUT=%h",
                         DATAOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATAOUT=%h",
                         expected_DATAOUT);
                $display("  Got:      DATAOUT=%h",
                         DATAOUT);
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
        $dumpvars(0,ADDR, CLK, DATAIN, OE, WE, DATAOUT);
    end

endmodule
