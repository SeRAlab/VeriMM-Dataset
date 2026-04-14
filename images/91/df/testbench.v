`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg E;
    reg RS;
    reg RW;
    reg [7:0] data;
    wire [15:0] pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .E(E),
        .RS(RS),
        .RW(RW),
        .data(data),
        .pixel(pixel)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RS = 0;
            RW = 0;
            E = 0;
            data = 8'h00;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Data Write 0xAA", test_num);
            RS = 1;
            RW = 0;
            data = 8'hAA;
            E = 1;
            @(posedge CLK);
            #2;
            E = 0;
            #1;

            check_outputs(16'h00AA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Data Write 0x55", test_num);
            RS = 1;
            RW = 0;
            data = 8'h55;
            E = 1;
            @(posedge CLK);
            #2;
            E = 0;
            #1;

            check_outputs(16'h0055);
        end
        endtask

    task testcase003;

        begin

            RS = 1; RW = 0; data = 8'hFF; E = 1;
            @(posedge CLK);
            #2;


            test_num = 3;
            $display("Testcase %03d: Command Clear (0x01)", test_num);
            RS = 0;
            RW = 0;
            data = 8'h01;
            E = 1;
            @(posedge CLK);
            #2;
            E = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Enable Gating Check (E=0)", test_num);


            RS = 1; RW = 0; data = 8'h12; E = 1;
            @(posedge CLK);
            #2;


            RS = 1; RW = 0; data = 8'h34; E = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(16'h0012);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Read Mode Check (RW=1)", test_num);


            RS = 1; RW = 0; data = 8'hCC; E = 1;
            @(posedge CLK);
            #2;


            RS = 1; RW = 1; data = 8'hDD; E = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(16'h00CC);
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
        input [15:0] expected_pixel;
        begin
            if (expected_pixel === (expected_pixel ^ pixel ^ expected_pixel)) begin
                $display("PASS");
                $display("  Outputs: pixel=%h",
                         pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel=%h",
                         expected_pixel);
                $display("  Got:      pixel=%h",
                         pixel);
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
        $dumpvars(0,CLK, E, RS, RW, data, pixel);
    end

endmodule
