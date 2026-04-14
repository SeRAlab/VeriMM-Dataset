`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D_i;
    reg clk_i;
    reg rd_i;
    reg reset_i;
    reg wr_i;
    wire [7:0] D_o;
    wire [7:0] wp_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D_i(D_i),
        .clk_i(clk_i),
        .rd_i(rd_i),
        .reset_i(reset_i),
        .wr_i(wr_i),
        .D_o(D_o),
        .wp_o(wp_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            reset_i = 1;
            rd_i = 0;
            wr_i = 0;
            D_i = 8'h00;
            @(posedge clk_i);
            #1;
            reset_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write Operation", test_num);
            reset_dut();
            D_i = 8'hA5;
            wr_i = 1;
            @(posedge clk_i);
            #1;
            wr_i = 0;

            #1;


            check_outputs(8'h00, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiple Write Operations", test_num);
            reset_dut();


            D_i = 8'h11; wr_i = 1; @(posedge clk_i); #1;

            D_i = 8'h22; wr_i = 1; @(posedge clk_i); #1;

            D_i = 8'h33; wr_i = 1; @(posedge clk_i); #1;

            wr_i = 0;

            #1;


            check_outputs(8'h00, 8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write then Read Operation", test_num);
            reset_dut();


            D_i = 8'h55;
            wr_i = 1;
            @(posedge clk_i);
            #1;
            wr_i = 0;


            rd_i = 1;
            @(posedge clk_i);
            #1;
            rd_i = 0;


            #1;



            check_outputs(8'h55, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Interleaved Read and Write", test_num);
            reset_dut();


            D_i = 8'hAA; wr_i = 1; @(posedge clk_i); #1;
            wr_i = 0;


            rd_i = 1; @(posedge clk_i); #1;
            rd_i = 0;


            D_i = 8'hBB; wr_i = 1; @(posedge clk_i); #1;
            wr_i = 0;


            rd_i = 1; @(posedge clk_i); #1;
            rd_i = 0;

            #1;


            check_outputs(8'hBB, 8'h02);
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
        input [7:0] expected_D_o;
        input [7:0] expected_wp_o;
        begin
            if (expected_D_o === (expected_D_o ^ D_o ^ expected_D_o) &&
                expected_wp_o === (expected_wp_o ^ wp_o ^ expected_wp_o)) begin
                $display("PASS");
                $display("  Outputs: D_o=%h, wp_o=%h",
                         D_o, wp_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_o=%h, wp_o=%h",
                         expected_D_o, expected_wp_o);
                $display("  Got:      D_o=%h, wp_o=%h",
                         D_o, wp_o);
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
        $dumpvars(0,D_i, clk_i, rd_i, reset_i, wr_i, D_o, wp_o);
    end

endmodule
