`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] BCD;
    reg clk;
    wire [6:0] SEG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BCD(BCD),
        .clk(clk),
        .SEG(SEG)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            BCD = 4'b0;

            repeat(3) @(posedge clk);
            #1;
        end
        endtask
    task testcase000;

        begin
            reset_dut();
            test_num = 0;
            BCD = 4'd0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b0111111);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            BCD = 4'd1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b0000110);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            BCD = 4'd2;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b1011011);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            BCD = 4'd3;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b1001111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            BCD = 4'd4;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b1100110);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            BCD = 4'd5;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b1101101);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            BCD = 4'd6;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b1111101);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            BCD = 4'd7;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b0000111);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            BCD = 4'd8;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            BCD = 4'd9;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b1101111);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            BCD = 4'd10;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b0000000);
        end
        endtask

    task testcase011;

        begin
            reset_dut();
            test_num = 11;
            BCD = 4'd15;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b0000000);
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


        testcase000();
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
        input [6:0] expected_SEG;
        begin
            if (expected_SEG === (expected_SEG ^ SEG ^ expected_SEG)) begin
                $display("PASS");
                $display("  Outputs: SEG=%h",
                         SEG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SEG=%h",
                         expected_SEG);
                $display("  Got:      SEG=%h",
                         SEG);
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
        $dumpvars(0,BCD, clk, SEG);
    end

endmodule
