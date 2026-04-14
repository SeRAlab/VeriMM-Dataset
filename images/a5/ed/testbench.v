`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg f36_dst_rdy_i;
    reg [7:0] ll_data;
    reg ll_eof_n;
    reg ll_sof_n;
    reg ll_src_rdy_n;
    reg reset;
    wire [35:0] f36_data;
    wire f36_src_rdy_o;
    wire ll_dst_rdy_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .f36_dst_rdy_i(f36_dst_rdy_i),
        .ll_data(ll_data),
        .ll_eof_n(ll_eof_n),
        .ll_sof_n(ll_sof_n),
        .ll_src_rdy_n(ll_src_rdy_n),
        .reset(reset),
        .f36_data(f36_data),
        .f36_src_rdy_o(f36_src_rdy_o),
        .ll_dst_rdy_n(ll_dst_rdy_n)
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
            f36_dst_rdy_i = 1;
            ll_data = 8'h0;
            ll_sof_n = 1;
            ll_eof_n = 1;
            ll_src_rdy_n = 1;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase001: 4-byte frame");
            reset_dut();
            @(posedge clk);


            ll_src_rdy_n = 0; ll_sof_n = 0; ll_eof_n = 1; ll_data = 8'h11;
            @(posedge clk);


            ll_sof_n = 1; ll_data = 8'h22;
            @(posedge clk);


            ll_data = 8'h33;
            @(posedge clk);


            ll_eof_n = 0; ll_data = 8'h44;
            @(posedge clk);

            ll_src_rdy_n = 1; ll_eof_n = 1;


            repeat(2) @(posedge clk);



            #1;




            check_outputs(36'hB11223344, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase002: 2-byte frame");
            reset_dut();
            @(posedge clk);


            ll_src_rdy_n = 0; ll_sof_n = 0; ll_eof_n = 1; ll_data = 8'hAA;
            @(posedge clk);


            ll_sof_n = 1; ll_eof_n = 0; ll_data = 8'hBB;
            @(posedge clk);

            ll_src_rdy_n = 1; ll_eof_n = 1;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(36'h9AABB0000, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase003: 5-byte frame");
            reset_dut();
            @(posedge clk);


            ll_src_rdy_n = 0; ll_sof_n = 0; ll_data = 8'h01; @(posedge clk);
            ll_sof_n = 1; ll_data = 8'h02; @(posedge clk);
            ll_data = 8'h03; @(posedge clk);
            ll_data = 8'h04; @(posedge clk);


            ll_eof_n = 0; ll_data = 8'h05; @(posedge clk);

            ll_src_rdy_n = 1; ll_eof_n = 1;



            wait(f36_src_rdy_o == 1);
            if (f36_data === 36'h801020304) pass_count = pass_count + 1;
            else fail_count = fail_count + 1;

            @(posedge clk);

            #1;


            check_outputs(36'h405000000, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase004: Clear operation");
            reset_dut();
            @(posedge clk);


            ll_src_rdy_n = 0; ll_sof_n = 0; ll_data = 8'hDE; @(posedge clk);
            ll_sof_n = 1; ll_data = 8'hAD; @(posedge clk);


            clear = 1; @(posedge clk);
            clear = 0; @(posedge clk);


            #1;



            check_outputs(36'h000000000, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase005: Backpressure");
            reset_dut();
            f36_dst_rdy_i = 0;
            @(posedge clk);


            ll_src_rdy_n = 0; ll_sof_n = 0; ll_data = 8'h11; @(posedge clk);
            ll_sof_n = 1; ll_data = 8'h22; @(posedge clk);
            ll_data = 8'h33; @(posedge clk);
            ll_eof_n = 0; ll_data = 8'h44; @(posedge clk);
            ll_src_rdy_n = 1;

            repeat(2) @(posedge clk);

            if (f36_src_rdy_o === 1'b1) begin
                 f36_dst_rdy_i = 1;
                 @(posedge clk);
                 #1;

                 check_outputs(36'hB11223344, 1'b1, 1'b0);
            end else begin
                 $display("  [FAIL] Source not ready despite data in buffer");
                 fail_count = fail_count + 1;
            end
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
        input [35:0] expected_f36_data;
        input expected_f36_src_rdy_o;
        input expected_ll_dst_rdy_n;
        begin
            if (expected_f36_data === (expected_f36_data ^ f36_data ^ expected_f36_data) &&
                expected_f36_src_rdy_o === (expected_f36_src_rdy_o ^ f36_src_rdy_o ^ expected_f36_src_rdy_o) &&
                expected_ll_dst_rdy_n === (expected_ll_dst_rdy_n ^ ll_dst_rdy_n ^ expected_ll_dst_rdy_n)) begin
                $display("PASS");
                $display("  Outputs: f36_data=%h, f36_src_rdy_o=%b, ll_dst_rdy_n=%b",
                         f36_data, f36_src_rdy_o, ll_dst_rdy_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f36_data=%h, f36_src_rdy_o=%b, ll_dst_rdy_n=%b",
                         expected_f36_data, expected_f36_src_rdy_o, expected_ll_dst_rdy_n);
                $display("  Got:      f36_data=%h, f36_src_rdy_o=%b, ll_dst_rdy_n=%b",
                         f36_data, f36_src_rdy_o, ll_dst_rdy_n);
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
        $dumpvars(0,clear, clk, f36_dst_rdy_i, ll_data, ll_eof_n, ll_sof_n, ll_src_rdy_n, reset, f36_data, f36_src_rdy_o, ll_dst_rdy_n);
    end

endmodule
