`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Sclk;
    reg [15:0] data_in;
    reg [7:0] data_rd_addr;
    reg [7:0] data_wr_addr;
    reg input_rdy_flag;
    reg rd_en;
    reg wr_en;
    wire [15:0] xin_data;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Sclk(Sclk),
        .data_in(data_in),
        .data_rd_addr(data_rd_addr),
        .data_wr_addr(data_wr_addr),
        .input_rdy_flag(input_rdy_flag),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .xin_data(xin_data),
        .zero_flag(zero_flag)
    );

    // Clock generation (10ns period)
    initial begin
        Sclk = 0;
        forever #5 Sclk = ~Sclk;
    end

        task reset_dut;

        begin
            Sclk = 0;
            data_in = 16'hFFFF;
            data_rd_addr = 0;
            data_wr_addr = 0;
            input_rdy_flag = 0;
            rd_en = 0;
            wr_en = 0;
            #15;

            input_rdy_flag = 1;
            #10;
            input_rdy_flag = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Basic Memory Write and Read", test_num);
            reset_dut();


            @(negedge Sclk);
            wr_en = 1;
            data_wr_addr = 8'h10;
            data_in = 16'hAAAA;

            @(negedge Sclk);
            wr_en = 0;


            rd_en = 1;
            data_rd_addr = 8'h10;
            #5;

            #1;


            check_outputs(16'hAAAA, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Trigger Zero Flag (800 consecutive zeros)", test_num);
            reset_dut();

            wr_en = 1;
            data_in = 16'h0000;


            for (i = 0; i < 800; i = i + 1) begin
                @(negedge Sclk);
            end

            #5;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Counter Reset with input_rdy_flag", test_num);
            reset_dut();

            wr_en = 1;
            data_in = 16'h0000;


            for (i = 0; i < 400; i = i + 1) begin
                @(negedge Sclk);
            end


            data_in = 16'h1234;
            #2;
            input_rdy_flag = 1;
            #10;
            input_rdy_flag = 0;


            data_in = 16'h0000;
            for (i = 0; i < 401; i = i + 1) begin
                @(negedge Sclk);
            end

            #5;

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Read Enable logic check", test_num);
            reset_dut();


            @(negedge Sclk);
            wr_en = 1;
            data_wr_addr = 8'h20;
            data_in = 16'h5555;

            @(negedge Sclk);
            wr_en = 0;


            rd_en = 0;
            data_rd_addr = 8'h20;
            #5;
            #1;

            check_outputs(16'h0000, 1'b0);
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
        input [15:0] expected_xin_data;
        input expected_zero_flag;
        begin
            if (expected_xin_data === (expected_xin_data ^ xin_data ^ expected_xin_data) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: xin_data=%h, zero_flag=%b",
                         xin_data, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xin_data=%h, zero_flag=%b",
                         expected_xin_data, expected_zero_flag);
                $display("  Got:      xin_data=%h, zero_flag=%b",
                         xin_data, zero_flag);
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
        $dumpvars(0,Sclk, data_in, data_rd_addr, data_wr_addr, input_rdy_flag, rd_en, wr_en, xin_data, zero_flag);
    end

endmodule
