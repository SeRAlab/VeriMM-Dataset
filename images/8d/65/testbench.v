`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] x;
    wire [7:0] xOut;
    wire [7:0] zOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .x(x),
        .xOut(xOut),
        .zOut(zOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            x <= 8'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Input 0x00", test_num);
            x <= 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Input 0x01", test_num);
            x <= 8'h01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h01, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Input 0xFF", test_num);
            x <= 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF, 8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Input 0x7F", test_num);
            x <= 8'h7F;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h7F, 8'h81);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Input 0x80", test_num);
            x <= 8'h80;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h80, 8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Input 0x55", test_num);
            x <= 8'h55;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h55, 8'hAB);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Input 0xAA", test_num);
            x <= 8'hAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA, 8'h56);
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
        input [7:0] expected_xOut;
        input [7:0] expected_zOut;
        begin
            if (expected_xOut === (expected_xOut ^ xOut ^ expected_xOut) &&
                expected_zOut === (expected_zOut ^ zOut ^ expected_zOut)) begin
                $display("PASS");
                $display("  Outputs: xOut=%h, zOut=%h",
                         xOut, zOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xOut=%h, zOut=%h",
                         expected_xOut, expected_zOut);
                $display("  Got:      xOut=%h, zOut=%h",
                         xOut, zOut);
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
        $dumpvars(0,clk, x, xOut, zOut);
    end

endmodule
