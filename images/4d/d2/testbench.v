`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg E;
    reg clk;
    reg [5:0] v1_reg;
    reg [5:0] v1_reg_0;
    reg wr_en;
    reg wr_rst_busy;
    wire [11:0] count;
    wire full;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .E(E),
        .clk(clk),
        .v1_reg(v1_reg),
        .v1_reg_0(v1_reg_0),
        .wr_en(wr_en),
        .wr_rst_busy(wr_rst_busy),
        .count(count),
        .full(full),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_rst_busy = 1;
            wr_en = 0;
            E = 0;
            v1_reg = 0;
            v1_reg_0 = 0;
            repeat(5) @(posedge clk);
            wr_rst_busy = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(12'd0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            v1_reg = 6'h3F;
            v1_reg_0 = 6'h00;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(12'd1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            for(i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                v1_reg = i[5:0];
                v1_reg_0 = ~i[5:0];
                wr_en = 1;
            end
            @(posedge clk);
            wr_en = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(12'd10, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            wr_en = 1;
            repeat(5) @(posedge clk);
            wr_en = 0;

            @(posedge clk);
            E = 1;
            repeat(2) @(posedge clk);
            E = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(12'd3, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            wr_rst_busy = 1;
            wr_en = 1;
            v1_reg = 6'h11;
            repeat(3) @(posedge clk);
            wr_en = 0;
            wr_rst_busy = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(12'd0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            v1_reg = 6'h01; v1_reg_0 = 6'h00;
            wr_en = 1;
            @(posedge clk);

            v1_reg = 6'h00; v1_reg_0 = 6'h00;
            @(posedge clk);
            wr_en = 0;
            E = 1;
            @(posedge clk);


            #1;



            check_outputs(12'd1, 1'b0, out);
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
        input [11:0] expected_count;
        input expected_full;
        input expected_out;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: count=%h, full=%b, out=%b",
                         count, full, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, full=%b, out=%b",
                         expected_count, expected_full, expected_out);
                $display("  Got:      count=%h, full=%b, out=%b",
                         count, full, out);
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
        $dumpvars(0,E, clk, v1_reg, v1_reg_0, wr_en, wr_rst_busy, count, full, out);
    end

endmodule
