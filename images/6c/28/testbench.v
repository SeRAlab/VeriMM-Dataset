`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] A;
    reg clk;
    wire [6:0] SEG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
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
            A = 3'b000;

            repeat (3) @(posedge clk);
            #1;
        end
        endtask
    task testcase000;

        begin
            reset_dut();
            test_num = 0;
            A = 3'd0;

            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 3'd1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 3'd2;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h5B);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 3'd3;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h4F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 3'd4;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 3'd5;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h6D);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 3'd6;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h7D);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            A = 3'd7;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            A = 3'd0;
            @(posedge clk);
            A = 3'd7;
            repeat (2) @(posedge clk);
            #1;

            #1;


            check_outputs(7'h07);
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
        $dumpvars(0,A, clk, SEG);
    end

endmodule
