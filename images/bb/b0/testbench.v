`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] ADDR;
    reg RD;
    reg WR;
    reg clk;
    reg [15:0] rddat0;
    reg [15:0] rddat1;
    reg [15:0] rddat2;
    reg [15:0] rddat3;
    reg [15:0] rddat4;
    reg [15:0] rddat5;
    reg rst_n;
    wire cs0;
    wire cs1;
    wire cs2;
    wire cs3;
    wire [15:0] wrdat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .RD(RD),
        .WR(WR),
        .clk(clk),
        .rddat0(rddat0),
        .rddat1(rddat1),
        .rddat2(rddat2),
        .rddat3(rddat3),
        .rddat4(rddat4),
        .rddat5(rddat5),
        .rst_n(rst_n),
        .cs0(cs0),
        .cs1(cs1),
        .cs2(cs2),
        .cs3(cs3),
        .wrdat(wrdat)
    );

    // Clock generation (10ns period)
    initial begin
        WR = 0;
        forever #5 WR = ~WR;
    end

        task reset_dut;

        begin
            rst_n = 0;
            ADDR = 0;
            RD = 0;
            WR = 0;
            drive_en = 0;
            data_to_dut = 0;
            rddat0 = 16'h0000; rddat1 = 16'h1111; rddat2 = 16'h2222;
            rddat3 = 16'h3333; rddat4 = 16'h4444; rddat5 = 16'h5555;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            ADDR = 12'h0AA;
            drive_en = 1;
            data_to_dut = 16'hCAFE;
            WR = 1;
            RD = 0;
            @(posedge clk);
            #1;
            WR = 0;
            drive_en = 0;

            #1;


            check_outputs(1, 0, 0, 0, 16'hCAFE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            ADDR = 12'h1BB;
            drive_en = 1;
            data_to_dut = 16'hBABE;
            WR = 1;
            RD = 0;
            @(posedge clk);
            #1;
            WR = 0;
            drive_en = 0;

            #1;


            check_outputs(0, 1, 0, 0, 16'hBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            ADDR = 12'h2CC;
            drive_en = 1;
            data_to_dut = 16'hDEAD;
            WR = 1;
            RD = 0;
            @(posedge clk);
            #1;
            WR = 0;
            drive_en = 0;

            #1;


            check_outputs(0, 0, 1, 0, 16'hDEAD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            ADDR = 12'h3DD;
            drive_en = 1;
            data_to_dut = 16'hBEEF;
            WR = 1;
            RD = 0;
            @(posedge clk);
            #1;
            WR = 0;
            drive_en = 0;

            #1;


            check_outputs(0, 0, 0, 1, 16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            ADDR = 12'h400;
            drive_en = 1;
            data_to_dut = 16'h5555;
            WR = 1;
            @(posedge clk);
            #1;
            WR = 0;
            drive_en = 0;

            #1;


            check_outputs(0, 0, 0, 0, 16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(posedge clk);
            ADDR = 12'h000; WR = 1; drive_en = 1; data_to_dut = 16'h1234;
            @(posedge clk);
            #1;

            WR = 0; drive_en = 0;
            ADDR = 12'h0FF;
            RD = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 0, 16'h1234);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(posedge clk);
            ADDR = 12'h201;
            RD = 1; WR = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1, 0, 16'h0000);
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
        input expected_cs0;
        input expected_cs1;
        input expected_cs2;
        input expected_cs3;
        input [15:0] expected_wrdat;
        begin
            if (expected_cs0 === (expected_cs0 ^ cs0 ^ expected_cs0) &&
                expected_cs1 === (expected_cs1 ^ cs1 ^ expected_cs1) &&
                expected_cs2 === (expected_cs2 ^ cs2 ^ expected_cs2) &&
                expected_cs3 === (expected_cs3 ^ cs3 ^ expected_cs3) &&
                expected_wrdat === (expected_wrdat ^ wrdat ^ expected_wrdat)) begin
                $display("PASS");
                $display("  Outputs: cs0=%b, cs1=%b, cs2=%b, cs3=%b, wrdat=%h",
                         cs0, cs1, cs2, cs3, wrdat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs0=%b, cs1=%b, cs2=%b, cs3=%b, wrdat=%h",
                         expected_cs0, expected_cs1, expected_cs2, expected_cs3, expected_wrdat);
                $display("  Got:      cs0=%b, cs1=%b, cs2=%b, cs3=%b, wrdat=%h",
                         cs0, cs1, cs2, cs3, wrdat);
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
        $dumpvars(0,ADDR, RD, WR, clk, rddat0, rddat1, rddat2, rddat3, rddat4, rddat5, rst_n, cs0, cs1, cs2, cs3, wrdat);
    end

endmodule
