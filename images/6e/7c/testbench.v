`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg En;
    reg clk;
    reg [7:0] data_save;
    reg reset;
    reg [3:0] sel_reg;
    wire [7:0] day;
    wire [7:0] hora;
    wire [7:0] hora_t;
    wire [7:0] min;
    wire [7:0] min_t;
    wire [7:0] month;
    wire [7:0] seg;
    wire [7:0] seg_t;
    wire [7:0] year;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .En(En),
        .clk(clk),
        .data_save(data_save),
        .reset(reset),
        .sel_reg(sel_reg),
        .day(day),
        .hora(hora),
        .hora_t(hora_t),
        .min(min),
        .min_t(min_t),
        .month(month),
        .seg(seg),
        .seg_t(seg_t),
        .year(year)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            En = 0;
            sel_reg = 0;
            data_save = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Sequential Register Loading");
            reset_dut();
            En = 1;


            sel_reg = 4'd0; data_save = 8'h10; @(posedge clk);

            sel_reg = 4'd1; data_save = 8'h20; @(posedge clk);

            sel_reg = 4'd2; data_save = 8'h30; @(posedge clk);

            sel_reg = 4'd3; data_save = 8'h05; @(posedge clk);

            sel_reg = 4'd4; data_save = 8'h12; @(posedge clk);

            sel_reg = 4'd5; data_save = 8'h24; @(posedge clk);

            sel_reg = 4'd6; data_save = 8'h45; @(posedge clk);

            sel_reg = 4'd7; data_save = 8'h55; @(posedge clk);

            sel_reg = 4'd8; data_save = 8'h07; @(posedge clk);

            #1;

            #1;


            check_outputs(8'h05, 8'h30, 8'h07, 8'h20, 8'h55, 8'h12, 8'h10, 8'h45, 8'h24);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Enable (En) Check");
            reset_dut();
            En = 0;


            sel_reg = 4'd5; data_save = 8'h99; @(posedge clk);

            #1;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Individual Update Persistence");
            reset_dut();
            En = 1;


            sel_reg = 4'd3; data_save = 8'h15; @(posedge clk);


            En = 0;
            sel_reg = 4'd3; data_save = 8'hFF; @(posedge clk);

            #1;

            #1;


            check_outputs(8'h15, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Boundary Value Check (All FF)");
            reset_dut();
            En = 1;


            sel_reg = 4'd6; data_save = 8'hFF; @(posedge clk);

            #1;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'h00);
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
        input [7:0] expected_day;
        input [7:0] expected_hora;
        input [7:0] expected_hora_t;
        input [7:0] expected_min;
        input [7:0] expected_min_t;
        input [7:0] expected_month;
        input [7:0] expected_seg;
        input [7:0] expected_seg_t;
        input [7:0] expected_year;
        begin
            if (expected_day === (expected_day ^ day ^ expected_day) &&
                expected_hora === (expected_hora ^ hora ^ expected_hora) &&
                expected_hora_t === (expected_hora_t ^ hora_t ^ expected_hora_t) &&
                expected_min === (expected_min ^ min ^ expected_min) &&
                expected_min_t === (expected_min_t ^ min_t ^ expected_min_t) &&
                expected_month === (expected_month ^ month ^ expected_month) &&
                expected_seg === (expected_seg ^ seg ^ expected_seg) &&
                expected_seg_t === (expected_seg_t ^ seg_t ^ expected_seg_t) &&
                expected_year === (expected_year ^ year ^ expected_year)) begin
                $display("PASS");
                $display("  Outputs: day=%h, hora=%h, hora_t=%h, min=%h, min_t=%h, month=%h, seg=%h, seg_t=%h, year=%h",
                         day, hora, hora_t, min, min_t, month, seg, seg_t, year);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: day=%h, hora=%h, hora_t=%h, min=%h, min_t=%h, month=%h, seg=%h, seg_t=%h, year=%h",
                         expected_day, expected_hora, expected_hora_t, expected_min, expected_min_t, expected_month, expected_seg, expected_seg_t, expected_year);
                $display("  Got:      day=%h, hora=%h, hora_t=%h, min=%h, min_t=%h, month=%h, seg=%h, seg_t=%h, year=%h",
                         day, hora, hora_t, min, min_t, month, seg, seg_t, year);
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
        $dumpvars(0,En, clk, data_save, reset, sel_reg, day, hora, hora_t, min, min_t, month, seg, seg_t, year);
    end

endmodule
