`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] emon_sel;
    reg [15:0] emon_vector;
    reg [31:0] reg_data;
    reg reg_write;
    reg reset;
    wire [31:0] emon_reg;
    wire emon_zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .emon_sel(emon_sel),
        .emon_vector(emon_vector),
        .reg_data(reg_data),
        .reg_write(reg_write),
        .reset(reset),
        .emon_reg(emon_reg),
        .emon_zero_flag(emon_zero_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        reg_write = 0;
        emon_sel = 0;
        emon_vector = 0;
        reg_data = 0;
        @(posedge clk);
        #1;
        reset = 0;

        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify Reset Initialization", test_num);
        reset_dut();

        #1;


        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify Register Write (Load Data)", test_num);
        reset_dut();

        reg_write = 1;
        reg_data = 32'h12345678;
        emon_vector = 16'h0000;
        @(posedge clk);
        #1;
        reg_write = 0;

        #1;


        check_outputs(32'h12345678, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify Decrement Logic (Bit 0)", test_num);
        reset_dut();


        reg_write = 1;
        reg_data = 32'd10;
        @(posedge clk);
        #1;


        reg_write = 0;
        emon_sel = 4'd0;
        emon_vector = 16'h0001;


        repeat(4) @(posedge clk);
        #1;


        #1;



        check_outputs(32'd6, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify Zero Flag and Reach Zero", test_num);
        reset_dut();


        reg_write = 1;
        reg_data = 32'd2;
        @(posedge clk);
        #1;


        reg_write = 0;
        emon_sel = 4'd3;
        emon_vector = 16'h0008;


        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(32'd0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify Register Remains Static when Selector is 0", test_num);
        reset_dut();


        reg_write = 1;
        reg_data = 32'd100;
        @(posedge clk);
        #1;


        reg_write = 0;
        emon_sel = 4'd7;
        emon_vector = 16'hFF7F;


        repeat(5) @(posedge clk);
        #1;


        #1;



        check_outputs(32'd100, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify Selector Bit 15", test_num);
        reset_dut();


        reg_write = 1;
        reg_data = 32'd50;
        @(posedge clk);
        #1;


        reg_write = 0;
        emon_sel = 4'd15;
        emon_vector = 16'h8000;


        repeat(10) @(posedge clk);
        #1;

        #1;


        check_outputs(32'd40, 1'b0);
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
        input [31:0] expected_emon_reg;
        input expected_emon_zero_flag;
        begin
            if (expected_emon_reg === (expected_emon_reg ^ emon_reg ^ expected_emon_reg) &&
                expected_emon_zero_flag === (expected_emon_zero_flag ^ emon_zero_flag ^ expected_emon_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: emon_reg=%h, emon_zero_flag=%b",
                         emon_reg, emon_zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: emon_reg=%h, emon_zero_flag=%b",
                         expected_emon_reg, expected_emon_zero_flag);
                $display("  Got:      emon_reg=%h, emon_zero_flag=%b",
                         emon_reg, emon_zero_flag);
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
        $dumpvars(0,clk, emon_sel, emon_vector, reg_data, reg_write, reset, emon_reg, emon_zero_flag);
    end

endmodule
