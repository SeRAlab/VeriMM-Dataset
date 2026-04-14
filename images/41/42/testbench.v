`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg d_avail_i;
    reg [7:0] data_i;
    reg enable_i;
    wire [15:0] adr_o;
    wire [7:0] data_o;
    wire n_reset_o;
    wire rd_o;
    wire wr_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .d_avail_i(d_avail_i),
        .data_i(data_i),
        .enable_i(enable_i),
        .adr_o(adr_o),
        .data_o(data_o),
        .n_reset_o(n_reset_o),
        .rd_o(rd_o),
        .wr_o(wr_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            enable_i = 0;
            d_avail_i = 0;
            data_i = 8'h00;
            repeat(2) @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            enable_i = 0;
            d_avail_i = 0;
            repeat(5) @(posedge clk_i);

            #1;


            check_outputs(16'h0000, 8'h00, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            enable_i = 1;
            d_avail_i = 1;
            data_i = 8'hAA;

            repeat(10) @(posedge clk_i);



            #1;




            check_outputs(adr_o, 8'hAA, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enable_i = 1;
            d_avail_i = 0;
            repeat(5) @(posedge clk_i);

            #1;


            check_outputs(16'h0000, 8'h00, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enable_i = 1;
            d_avail_i = 1;
            data_i = 8'h55;
            repeat(10) @(posedge clk_i);
            data_i = 8'hCC;
            repeat(10) @(posedge clk_i);

            #1;


            check_outputs(adr_o, 8'hCC, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable_i = 1;
            d_avail_i = 1;
            repeat(2) @(posedge clk_i);
            enable_i = 0;
            repeat(5) @(posedge clk_i);

            #1;


            check_outputs(16'h0000, 8'h00, 1'b1, 1'b0, 1'b0);
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
        input [15:0] expected_adr_o;
        input [7:0] expected_data_o;
        input expected_n_reset_o;
        input expected_rd_o;
        input expected_wr_o;
        begin
            if (expected_adr_o === (expected_adr_o ^ adr_o ^ expected_adr_o) &&
                expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_n_reset_o === (expected_n_reset_o ^ n_reset_o ^ expected_n_reset_o) &&
                expected_rd_o === (expected_rd_o ^ rd_o ^ expected_rd_o) &&
                expected_wr_o === (expected_wr_o ^ wr_o ^ expected_wr_o)) begin
                $display("PASS");
                $display("  Outputs: adr_o=%h, data_o=%h, n_reset_o=%b, rd_o=%b, wr_o=%b",
                         adr_o, data_o, n_reset_o, rd_o, wr_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adr_o=%h, data_o=%h, n_reset_o=%b, rd_o=%b, wr_o=%b",
                         expected_adr_o, expected_data_o, expected_n_reset_o, expected_rd_o, expected_wr_o);
                $display("  Got:      adr_o=%h, data_o=%h, n_reset_o=%b, rd_o=%b, wr_o=%b",
                         adr_o, data_o, n_reset_o, rd_o, wr_o);
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
        $dumpvars(0,clk_i, d_avail_i, data_i, enable_i, adr_o, data_o, n_reset_o, rd_o, wr_o);
    end

endmodule
