`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    reg reset;
    wire [7:0] out_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .out_sum(out_sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 16'h0000;
            @(posedge clk);
            #2;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            in = 16'h050A;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            in = 16'h1010;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h21);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            in = 16'hFF02;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            in = 16'h0000;

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
            end




            in = 16'h0101;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            in = 16'hF0F0;

            repeat(5) @(posedge clk);
            in = 16'hAAAA;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h59);
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
        input [7:0] expected_out_sum;
        begin
            if (expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum)) begin
                $display("PASS");
                $display("  Outputs: out_sum=%h",
                         out_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_sum=%h",
                         expected_out_sum);
                $display("  Got:      out_sum=%h",
                         out_sum);
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
        $dumpvars(0,clk, in, reset, out_sum);
    end

endmodule
