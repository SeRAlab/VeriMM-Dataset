`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] hex;
    wire [6:0] symbol;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hex(hex),
        .symbol(symbol)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            hex = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            hex = 4'h0;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b0111111);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            hex = 4'h1;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b0000110);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            hex = 4'h2;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b1011011);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            hex = 4'h3;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b1001111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            hex = 4'h4;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b1100110);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            hex = 4'h5;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b1101101);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            hex = 4'h6;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b1111101);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            hex = 4'h7;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b0000111);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            hex = 4'h8;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            hex = 4'h9;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b1101111);
        end
        endtask

    task testcase011;

        begin
            reset_dut();
            test_num = 11;
            hex = 4'hA;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b1110111);
        end
        endtask

    task testcase012;

        begin
            reset_dut();
            test_num = 12;
            hex = 4'hB;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b1111100);
        end
        endtask

    task testcase013;

        begin
            reset_dut();
            test_num = 13;
            hex = 4'hC;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b0111001);
        end
        endtask

    task testcase014;

        begin
            reset_dut();
            test_num = 14;
            hex = 4'hD;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b1011110);
        end
        endtask

    task testcase015;

        begin
            reset_dut();
            test_num = 15;
            hex = 4'hE;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b1111001);
        end
        endtask

    task testcase016;

        begin
            reset_dut();
            test_num = 16;
            hex = 4'hF;
            @(posedge clk); #1;
            #1;

            check_outputs(7'b1110001);
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
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [6:0] expected_symbol;
        begin
            if (expected_symbol === (expected_symbol ^ symbol ^ expected_symbol)) begin
                $display("PASS");
                $display("  Outputs: symbol=%h",
                         symbol);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: symbol=%h",
                         expected_symbol);
                $display("  Got:      symbol=%h",
                         symbol);
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
        $dumpvars(0,clk, hex, symbol);
    end

endmodule
