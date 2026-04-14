`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg data_valid;
    reg rst_n;
    wire [7:0] kmouse_buttons;
    wire [7:0] kmouse_x;
    wire [7:0] kmouse_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .data_valid(data_valid),
        .rst_n(rst_n),
        .kmouse_buttons(kmouse_buttons),
        .kmouse_x(kmouse_x),
        .kmouse_y(kmouse_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data = 0;
            data_valid = 0;
            repeat(5) @(posedge clk);
            #1 rst_n = 1;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Positive Movement (+10, +20)", test_num);
            reset_dut();

            send_packet(8'h08, 8'd10, 8'd20);
            #1;

            check_outputs(8'h08, 8'd10, 8'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Negative Movement (-5, -10)", test_num);
            reset_dut();

            send_packet(8'h08, 8'd50, 8'd50);



            send_packet(8'h38, 8'hFB, 8'hF6);

            #1;


            check_outputs(8'h38, 8'h2D, 8'h28);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Button Presses (Left and Right)", test_num);
            reset_dut();


            send_packet(8'h09, 8'h00, 8'h00);
            #1;

            check_outputs(8'h09, 8'h00, 8'h00);


            send_packet(8'h0A, 8'h00, 8'h00);
            #1;

            check_outputs(8'h0A, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Cumulative Movement", test_num);
            reset_dut();
            send_packet(8'h08, 8'd5, 8'd5);
            send_packet(8'h08, 8'd10, 8'd10);
            send_packet(8'h08, 8'd2, 8'd3);
            #1;

            check_outputs(8'h08, 8'd17, 8'd18);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Data Valid Gating", test_num);
            reset_dut();
            send_packet(8'h08, 8'd10, 8'd10);


            data = 8'hFF;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(8'h08, 8'd10, 8'd10);
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
        input [7:0] expected_kmouse_buttons;
        input [7:0] expected_kmouse_x;
        input [7:0] expected_kmouse_y;
        begin
            if (expected_kmouse_buttons === (expected_kmouse_buttons ^ kmouse_buttons ^ expected_kmouse_buttons) &&
                expected_kmouse_x === (expected_kmouse_x ^ kmouse_x ^ expected_kmouse_x) &&
                expected_kmouse_y === (expected_kmouse_y ^ kmouse_y ^ expected_kmouse_y)) begin
                $display("PASS");
                $display("  Outputs: kmouse_buttons=%h, kmouse_x=%h, kmouse_y=%h",
                         kmouse_buttons, kmouse_x, kmouse_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: kmouse_buttons=%h, kmouse_x=%h, kmouse_y=%h",
                         expected_kmouse_buttons, expected_kmouse_x, expected_kmouse_y);
                $display("  Got:      kmouse_buttons=%h, kmouse_x=%h, kmouse_y=%h",
                         kmouse_buttons, kmouse_x, kmouse_y);
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
        $dumpvars(0,clk, data, data_valid, rst_n, kmouse_buttons, kmouse_x, kmouse_y);
    end

endmodule
