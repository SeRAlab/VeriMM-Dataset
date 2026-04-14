`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg ENA;
    reg [1:0] KEY;
    reg [7:0] OPT;
    reg [7:0] RGA;
    reg RGB;
    reg RST;
    wire [7:0] RGZ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .ENA(ENA),
        .KEY(KEY),
        .OPT(OPT),
        .RGA(RGA),
        .RGB(RGB),
        .RST(RST),
        .RGZ(RGZ)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            ENA = 0;
            RGA = 0;
            RGB = 0;
            OPT = 0;
            KEY = 0;
            @(posedge CLK);
            #2 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            ENA = 1;
            RGA = 8'h01;
            OPT = 8'h03;
            KEY = 2'b00;
            RGB = 1'b1;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'h08);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            ENA = 1;
            RGA = 8'h80;
            OPT = 8'h02;
            KEY = 2'b01;
            RGB = 1'b1;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'h20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            ENA = 1;
            RGA = 8'hAA;
            KEY = 2'b00;
            RGB = 1'b0;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            ENA = 1;
            RGA = 8'hFF;
            KEY = 2'b10;
            RGB = 1'b0;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            ENA = 0;
            RGA = 8'hFF;
            RGB = 1'b0;
            KEY = 2'b00;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            ENA = 1;
            RGA = 8'hFF;
            OPT = 8'h08;
            KEY = 2'b00;
            RGB = 1'b1;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'h00);
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
        input [7:0] expected_RGZ;
        begin
            if (expected_RGZ === (expected_RGZ ^ RGZ ^ expected_RGZ)) begin
                $display("PASS");
                $display("  Outputs: RGZ=%h",
                         RGZ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RGZ=%h",
                         expected_RGZ);
                $display("  Got:      RGZ=%h",
                         RGZ);
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
        $dumpvars(0,CLK, ENA, KEY, OPT, RGA, RGB, RST, RGZ);
    end

endmodule
