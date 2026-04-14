`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    wire [31:0] comp_concat_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .comp_concat_out(comp_concat_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: All Zeros");
            reset_dut();
            data_in = 16'h0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFF00FF00);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: All Ones");
            reset_dut();
            data_in = 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00FF00FF);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Alternating Nibbles (1234)");
            reset_dut();
            data_in = 16'h1234;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hED12CB34);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Bitwise Checkerboard (AAAA)");
            reset_dut();
            data_in = 16'hAAAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h55AA55AA);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Mixed Pattern (A5C3)");
            reset_dut();
            data_in = 16'hA5C3;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h5AA53CC3);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Boundary Bits (8001)");
            reset_dut();
            data_in = 16'h8001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h7F80FE01);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Complementary High/Low (55AA)");
            reset_dut();
            data_in = 16'h55AA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hAA5555AA);
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
        input [31:0] expected_comp_concat_out;
        begin
            if (expected_comp_concat_out === (expected_comp_concat_out ^ comp_concat_out ^ expected_comp_concat_out)) begin
                $display("PASS");
                $display("  Outputs: comp_concat_out=%h",
                         comp_concat_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp_concat_out=%h",
                         expected_comp_concat_out);
                $display("  Got:      comp_concat_out=%h",
                         comp_concat_out);
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
        $dumpvars(0,clk, data_in, comp_concat_out);
    end

endmodule
