`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk25;
    reg reset;
    wire draw;
    wire hSync;
    wire vSync;
    wire [7:0] xCoord;
    wire [8:0] yCoord;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk25(clk25),
        .reset(reset),
        .draw(draw),
        .hSync(hSync),
        .vSync(vSync),
        .xCoord(xCoord),
        .yCoord(yCoord)
    );

    // Clock generation (10ns period)
    initial begin
        clk25 = 0;
        forever #5 clk25 = ~clk25;
    end

        task reset_dut;

        begin
            reset = 1;
            wait_cycles(2);
            #1;
            reset = 0;
            @(posedge clk25);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Initial State (Pixel 0,0)");
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 8'd0, 9'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: End of Drawing Area (Pixel 255,0)");
            reset_dut();
            wait_cycles(255);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 8'd255, 9'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Horizontal Blanking Area Start (Pixel 256,0)");
            reset_dut();
            wait_cycles(256);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 8'd0, 9'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Horizontal Sync Pulse (Pixel 700)");
            reset_dut();
            wait_cycles(700);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 8'd188, 9'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Row Increment (Pixel 0,1)");
            reset_dut();
            wait_cycles(800);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 8'd0, 9'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Vertical Drawing Area End (Row 320)");
            reset_dut();
            wait_cycles(800 * 320);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 8'd0, 9'd320);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Vertical Sync Pulse (Row 490)");
            reset_dut();
            wait_cycles(800 * 490);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 8'd0, 9'd490);
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
        input expected_draw;
        input expected_hSync;
        input expected_vSync;
        input [7:0] expected_xCoord;
        input [8:0] expected_yCoord;
        begin
            if (expected_draw === (expected_draw ^ draw ^ expected_draw) &&
                expected_hSync === (expected_hSync ^ hSync ^ expected_hSync) &&
                expected_vSync === (expected_vSync ^ vSync ^ expected_vSync) &&
                expected_xCoord === (expected_xCoord ^ xCoord ^ expected_xCoord) &&
                expected_yCoord === (expected_yCoord ^ yCoord ^ expected_yCoord)) begin
                $display("PASS");
                $display("  Outputs: draw=%b, hSync=%b, vSync=%b, xCoord=%h, yCoord=%h",
                         draw, hSync, vSync, xCoord, yCoord);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: draw=%b, hSync=%b, vSync=%b, xCoord=%h, yCoord=%h",
                         expected_draw, expected_hSync, expected_vSync, expected_xCoord, expected_yCoord);
                $display("  Got:      draw=%b, hSync=%b, vSync=%b, xCoord=%h, yCoord=%h",
                         draw, hSync, vSync, xCoord, yCoord);
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
        $dumpvars(0,clk25, reset, draw, hSync, vSync, xCoord, yCoord);
    end

endmodule
