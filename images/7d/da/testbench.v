`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg kc;
    reg kd;
    reg rst;
    wire [7:0] data;
    wire kbs;
    wire parity_error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .kc(kc),
        .kd(kd),
        .rst(rst),
        .data(data),
        .kbs(kbs),
        .parity_error(parity_error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            kc = 1;
            kd = 1;
            repeat(5) @(posedge clk);
            rst = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task send_ps2_bit;

        input bit_val;
        begin
            kd = bit_val;
            #2000;
            kc = 0;
            #5000;
            kc = 1;
            #3000;
        end
        endtask

    task send_ps2_frame;

        input [7:0] byte_to_send;
        input parity_bit;
        integer i;
        begin

            send_ps2_bit(0);

            for (i = 0; i < 8; i = i + 1) begin
                send_ps2_bit(byte_to_send[i]);
            end

            send_ps2_bit(parity_bit);

            send_ps2_bit(1);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Valid frame 0x1C", test_num);
            reset_dut();
            send_ps2_frame(8'h1C, 0);
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h1C, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Valid frame 0x55", test_num);
            reset_dut();
            send_ps2_frame(8'h55, 1);
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h55, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Parity Error Check (0x1C)", test_num);
            reset_dut();
            send_ps2_frame(8'h1C, 1);
            repeat(10) @(posedge clk);

            #1;


            check_outputs(8'h1C, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Valid frame 0xF0", test_num);
            reset_dut();
            send_ps2_frame(8'hF0, 0);

            reset_dut();
            send_ps2_frame(8'hF0, 1);
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'hF0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Consecutive data bytes", test_num);
            reset_dut();

            send_ps2_frame(8'hAA, 1);
            repeat(20) @(posedge clk);

            send_ps2_frame(8'h01, 0);
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h01, 1'b1, 1'b0);
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
        input [7:0] expected_data;
        input expected_kbs;
        input expected_parity_error;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_kbs === (expected_kbs ^ kbs ^ expected_kbs) &&
                expected_parity_error === (expected_parity_error ^ parity_error ^ expected_parity_error)) begin
                $display("PASS");
                $display("  Outputs: data=%h, kbs=%b, parity_error=%b",
                         data, kbs, parity_error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, kbs=%b, parity_error=%b",
                         expected_data, expected_kbs, expected_parity_error);
                $display("  Got:      data=%h, kbs=%b, parity_error=%b",
                         data, kbs, parity_error);
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
        $dumpvars(0,clk, kc, kd, rst, data, kbs, parity_error);
    end

endmodule
