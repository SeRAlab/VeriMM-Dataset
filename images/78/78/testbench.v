`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg ENA;
    reg [1:0] KEY;
    reg [7:0] RGA;
    reg [7:0] RGB;
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
            RST = 0;
            ENA = 0;
            RGA = 8'h00;
            RGB = 8'h00;
            KEY = 2'b00;
            #15;
            RST = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge CLK);
            ENA = 1;
            RGA = 8'hAA;
            RGB = 8'hF0;
            KEY = 2'b00;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(8'hAA & 8'hF0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge CLK);
            ENA = 1;
            RGA = 8'h55;
            RGB = 8'h0F;
            KEY = 2'b01;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(8'h55 | 8'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge CLK);
            ENA = 1;
            RGA = 8'hCC;
            RGB = 8'h33;
            KEY = 2'b10;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(8'hCC ^ 8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge CLK);
            ENA = 1;
            RGA = 8'h0F;
            KEY = 2'b11;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(~8'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge CLK);
            ENA = 1; RGA = 8'hA5; RGB = 8'h5A;
            @(negedge CLK);

            @(posedge CLK);
            ENA = 0; RGA = 8'hFF; RGB = 8'hFF;
            KEY = 2'b10;
            @(negedge CLK);
            #2;

            #1;


            check_outputs(8'hA5 ^ 8'h5A);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge CLK);
            ENA = 1; RGA = 8'hFF; RGB = 8'hFF;
            @(negedge CLK);
            #2;
            RST = 0;
            #2;
            #1;

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
        $dumpvars(0,CLK, ENA, KEY, RGA, RGB, RST, RGZ);
    end

endmodule
