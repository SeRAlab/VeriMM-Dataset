`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pop_i;
    reg rst;
    reg [8:0] x_i;
    reg [6:0] y_i;
    wire ack_o;
    wire [5:0] b_o;
    wire [5:0] g_o;
    wire [5:0] r_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pop_i(pop_i),
        .rst(rst),
        .x_i(x_i),
        .y_i(y_i),
        .ack_o(ack_o),
        .b_o(b_o),
        .g_o(g_o),
        .r_o(r_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pop_i = 0;
            x_i = 0;
            y_i = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Origin (0,0)", test_num);
            x_i = 9'd0;
            y_i = 7'd0;
            pop_i = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 6'd0, 6'd0, 6'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Max Coordinates (511, 127)", test_num);
            x_i = 9'd511;
            y_i = 7'd127;
            pop_i = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 6'd62, 6'd63, 6'd63);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Mid-range (10, 20)", test_num);
            x_i = 9'd10;
            y_i = 7'd20;
            pop_i = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 6'd30, 6'd20, 6'd10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Idle (pop_i=0)", test_num);
            x_i = 9'd50;
            y_i = 7'd50;
            pop_i = 1'b0;
            @(posedge clk);
            #1;

            if (ack_o !== 1'b0) begin
                $display("FAIL: ack_o should be 0 when pop_i is 0");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Wrap (64, 0)", test_num);
            x_i = 9'd64;
            y_i = 7'd0;
            pop_i = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 6'd0, 6'd0, 6'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Rapid coordinate change", test_num);
            x_i = 9'd5;
            y_i = 7'd5;
            pop_i = 1'b1;
            @(posedge clk);
            x_i = 9'd1;
            y_i = 7'd1;
            #1;
            #1;

            check_outputs(1'b1, 6'd10, 6'd5, 6'd5);
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
        input expected_ack_o;
        input [5:0] expected_b_o;
        input [5:0] expected_g_o;
        input [5:0] expected_r_o;
        begin
            if (expected_ack_o === (expected_ack_o ^ ack_o ^ expected_ack_o) &&
                expected_b_o === (expected_b_o ^ b_o ^ expected_b_o) &&
                expected_g_o === (expected_g_o ^ g_o ^ expected_g_o) &&
                expected_r_o === (expected_r_o ^ r_o ^ expected_r_o)) begin
                $display("PASS");
                $display("  Outputs: ack_o=%b, b_o=%h, g_o=%h, r_o=%h",
                         ack_o, b_o, g_o, r_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_o=%b, b_o=%h, g_o=%h, r_o=%h",
                         expected_ack_o, expected_b_o, expected_g_o, expected_r_o);
                $display("  Got:      ack_o=%b, b_o=%h, g_o=%h, r_o=%h",
                         ack_o, b_o, g_o, r_o);
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
        $dumpvars(0,clk, pop_i, rst, x_i, y_i, ack_o, b_o, g_o, r_o);
    end

endmodule
