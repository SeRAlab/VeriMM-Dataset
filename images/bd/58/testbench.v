`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [35:0] data_i;
    reg dst_rdy_i;
    reg reset;
    reg shutoff;
    reg src_rdy_i;
    wire [35:0] data_o;
    wire dst_rdy_o;
    wire src_rdy_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .data_i(data_i),
        .dst_rdy_i(dst_rdy_i),
        .reset(reset),
        .shutoff(shutoff),
        .src_rdy_i(src_rdy_i),
        .data_o(data_o),
        .dst_rdy_o(dst_rdy_o),
        .src_rdy_o(src_rdy_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clear = 0;
            shutoff = 0;
            data_i = 36'h0;
            src_rdy_i = 0;
            dst_rdy_i = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data_i = 36'hA5A5A5A5A;
            src_rdy_i = 1;
            dst_rdy_i = 1;
            @(posedge clk);

            #1;


            check_outputs(36'hA5A5A5A5A, 1, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data_i = 36'h123456789;
            src_rdy_i = 1;
            dst_rdy_i = 1;
            shutoff = 1;
            @(posedge clk);
            shutoff = 0;
            @(posedge clk);

            #1;


            check_outputs(36'h123456789, 1, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            shutoff = 1;
            @(posedge clk);
            shutoff = 0;
            @(posedge clk);

            clear = 1;
            @(posedge clk);
            clear = 0;
            data_i = 36'hFEEDC0DE0;
            src_rdy_i = 1;
            dst_rdy_i = 1;
            @(posedge clk);

            #1;


            check_outputs(36'hFEEDC0DE0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data_i = 36'h000000000;
            src_rdy_i = 1;
            dst_rdy_i = 0;
            @(posedge clk);

            #1;


            check_outputs(36'h000000000, 0, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            shutoff = 1;
            @(posedge clk);
            shutoff = 0;
            dst_rdy_i = 1;
            data_i = 36'hBADC0FFEE;
            @(posedge clk);
            dst_rdy_i = 0;
            @(posedge clk);

            #1;


            check_outputs(36'hBADC0FFEE, 0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            shutoff = 1;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            data_i = 36'hAAAAAAAAA;
            src_rdy_i = 1;
            dst_rdy_i = 1;
            @(posedge clk);
            #1;

            check_outputs(36'hAAAAAAAAA, 1, 1);
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
        input [35:0] expected_data_o;
        input expected_dst_rdy_o;
        input expected_src_rdy_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_dst_rdy_o === (expected_dst_rdy_o ^ dst_rdy_o ^ expected_dst_rdy_o) &&
                expected_src_rdy_o === (expected_src_rdy_o ^ src_rdy_o ^ expected_src_rdy_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, dst_rdy_o=%b, src_rdy_o=%b",
                         data_o, dst_rdy_o, src_rdy_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, dst_rdy_o=%b, src_rdy_o=%b",
                         expected_data_o, expected_dst_rdy_o, expected_src_rdy_o);
                $display("  Got:      data_o=%h, dst_rdy_o=%b, src_rdy_o=%b",
                         data_o, dst_rdy_o, src_rdy_o);
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
        $dumpvars(0,clear, clk, data_i, dst_rdy_i, reset, shutoff, src_rdy_i, data_o, dst_rdy_o, src_rdy_o);
    end

endmodule
