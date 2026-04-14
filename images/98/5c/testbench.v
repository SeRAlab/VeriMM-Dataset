`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dsp0;
    reg [7:0] dsp1;
    reg [7:0] dsp2;
    reg [7:0] dsp3;
    reg rst_n;
    wire [7:0] BCD;
    wire [3:0] BCD_c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dsp0(dsp0),
        .dsp1(dsp1),
        .dsp2(dsp2),
        .dsp3(dsp3),
        .rst_n(rst_n),
        .BCD(BCD),
        .BCD_c(BCD_c)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            dsp0 = 8'h00; dsp1 = 8'h00; dsp2 = 8'h00; dsp3 = 8'h00;
            repeat(2) @(posedge clk);
            #2 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Check Digit 0 (dsp0) immediately after reset", test_num);
            reset_dut();
            dsp0 = 8'hA1; dsp1 = 8'hB2; dsp2 = 8'hC3; dsp3 = 8'hD4;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'hA1, 4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Advance counter to Digit 1 (dsp1)", test_num);
            reset_dut();
            dsp0 = 8'h11; dsp1 = 8'h22; dsp2 = 8'h33; dsp3 = 8'h44;

            repeat(262144 + 100) @(posedge clk);
            #1;

            check_outputs(8'h22, 4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Advance counter to Digit 2 (dsp2)", test_num);
            reset_dut();
            dsp0 = 8'h11; dsp1 = 8'h22; dsp2 = 8'h33; dsp3 = 8'h44;

            repeat(524288 + 100) @(posedge clk);
            #1;

            check_outputs(8'h33, 4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Advance counter to Digit 3 (dsp3)", test_num);
            reset_dut();
            dsp0 = 8'h11; dsp1 = 8'h22; dsp2 = 8'h33; dsp3 = 8'h44;

            repeat(786432 + 100) @(posedge clk);
            #1;

            check_outputs(8'h44, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Check rollover from Digit 3 back to Digit 0", test_num);
            reset_dut();
            dsp0 = 8'h99; dsp1 = 8'h88; dsp2 = 8'h77; dsp3 = 8'h66;

            repeat(1048576 + 100) @(posedge clk);
            #1;

            check_outputs(8'h99, 4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify asynchronous reset mid-cycle", test_num);
            reset_dut();
            dsp0 = 8'hAA; dsp1 = 8'hBB;
            repeat(262144 + 100) @(posedge clk);
            rst_n = 0;
            #15;
            rst_n = 1;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'hAA, 4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify output updates when input dsp changes", test_num);
            reset_dut();
            dsp0 = 8'h10;
            repeat(100) @(posedge clk);
            dsp0 = 8'hFF;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'hFF, 4'b0001);
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
        input [7:0] expected_BCD;
        input [3:0] expected_BCD_c;
        begin
            if (expected_BCD === (expected_BCD ^ BCD ^ expected_BCD) &&
                expected_BCD_c === (expected_BCD_c ^ BCD_c ^ expected_BCD_c)) begin
                $display("PASS");
                $display("  Outputs: BCD=%h, BCD_c=%h",
                         BCD, BCD_c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD=%h, BCD_c=%h",
                         expected_BCD, expected_BCD_c);
                $display("  Got:      BCD=%h, BCD_c=%h",
                         BCD, BCD_c);
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
        $dumpvars(0,clk, dsp0, dsp1, dsp2, dsp3, rst_n, BCD, BCD_c);
    end

endmodule
