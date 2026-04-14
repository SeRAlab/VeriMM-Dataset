`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg rx_clk;
    reg rx_rst;
    reg [31:0] rx_x;
    reg [31:0] rx_y;
    reg [11:0] rx_z;
    wire [31:0] tx_x;
    wire [31:0] tx_y;
    wire [11:0] tx_z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rx_clk(rx_clk),
        .rx_rst(rx_rst),
        .rx_x(rx_x),
        .rx_y(rx_y),
        .rx_z(rx_z),
        .tx_x(tx_x),
        .tx_y(tx_y),
        .tx_z(tx_z)
    );

    // Clock generation (10ns period)
    initial begin
        rx_clk = 0;
        forever #5 rx_clk = ~rx_clk;
    end

        task reset_dut;

        begin
            rx_rst = 1;
            rx_x = 0;
            rx_y = 0;
            rx_z = 0;
            @(posedge rx_clk);
            #1 rx_rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Reset verification", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 12'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Quadrant 1 (x=100, y=50)", test_num);
            rx_x = 32'd100;
            rx_y = 32'd50;
            rx_z = 12'h123;
            @(posedge rx_clk);
            #1;
            #1;

            check_outputs(32'd100, 32'd50, 12'h123);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Quadrant 4 (x=100, y=-50)", test_num);
            rx_x = 32'd100;
            rx_y = -32'd50;
            rx_z = 12'h000;
            @(posedge rx_clk);
            #1;
            #1;

            check_outputs(32'd100, -32'd50, 12'h000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Quadrant 2 (x=-100, y=50)", test_num);
            rx_x = -32'd100;
            rx_y = 32'd50;
            rx_z = 12'h010;
            @(posedge rx_clk);
            #1;
            #1;

            check_outputs(32'd50, 32'd100, 12'h010 + ANGLE_90);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Quadrant 3 (x=-100, y=-50)", test_num);
            rx_x = -32'd100;
            rx_y = -32'd50;
            rx_z = 12'h000;
            @(posedge rx_clk);
            #1;
            #1;

            check_outputs(32'd50, -32'd100, ANGLE_N90);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Negative X axis (x=-500, y=0)", test_num);
            rx_x = -32'd500;
            rx_y = 32'd0;
            rx_z = 12'h000;
            @(posedge rx_clk);
            #1;

            #1;


            check_outputs(32'd0, 32'd500, ANGLE_90);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Origin point (x=0, y=0)", test_num);
            rx_x = 32'd0;
            rx_y = 32'd0;
            rx_z = 12'hABC;
            @(posedge rx_clk);
            #1;
            #1;

            check_outputs(32'd0, 32'd0, 12'hABC);
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
        testcase007();
        
        
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
        input [31:0] expected_tx_x;
        input [31:0] expected_tx_y;
        input [11:0] expected_tx_z;
        begin
            if (expected_tx_x === (expected_tx_x ^ tx_x ^ expected_tx_x) &&
                expected_tx_y === (expected_tx_y ^ tx_y ^ expected_tx_y) &&
                expected_tx_z === (expected_tx_z ^ tx_z ^ expected_tx_z)) begin
                $display("PASS");
                $display("  Outputs: tx_x=%h, tx_y=%h, tx_z=%h",
                         tx_x, tx_y, tx_z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_x=%h, tx_y=%h, tx_z=%h",
                         expected_tx_x, expected_tx_y, expected_tx_z);
                $display("  Got:      tx_x=%h, tx_y=%h, tx_z=%h",
                         tx_x, tx_y, tx_z);
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
        $dumpvars(0,rx_clk, rx_rst, rx_x, rx_y, rx_z, tx_x, tx_y, tx_z);
    end

endmodule
