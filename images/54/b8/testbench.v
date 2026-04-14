`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg brg_en;
    reg clk;
    reg rst;
    reg rx_in;
    wire shift_0;
    wire shift_15;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .brg_en(brg_en),
        .clk(clk),
        .rst(rst),
        .rx_in(rx_in),
        .shift_0(shift_0),
        .shift_15(shift_15)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            brg_en = 0;
            rx_in = 1;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Single Bit Shift (0)", test_num);
            reset_dut();
            brg_en = 1;
            rx_in = 0;
            @(posedge clk);
            #1;
            brg_en = 0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Test Case %0d: Full Shift Out (16 zeros)", test_num);
            reset_dut();
            brg_en = 1;
            rx_in = 0;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            brg_en = 0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Test Case %0d: MSB update after clear", test_num);
            reset_dut();
            brg_en = 1;
            rx_in = 0;
            repeat(16) @(posedge clk);
            #1;
            rx_in = 1;
            @(posedge clk);
            #1;
            brg_en = 0;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: brg_en Gating Verification", test_num);
            reset_dut();
            brg_en = 0;
            rx_in = 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Test Case %0d: Propagation to LSB", test_num);
            reset_dut();
            brg_en = 1;
            rx_in = 0;
            repeat(15) @(posedge clk);
            #1;
            brg_en = 0;


            #1;



            check_outputs(1'b1, 1'b0);
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
        input expected_shift_0;
        input expected_shift_15;
        begin
            if (expected_shift_0 === (expected_shift_0 ^ shift_0 ^ expected_shift_0) &&
                expected_shift_15 === (expected_shift_15 ^ shift_15 ^ expected_shift_15)) begin
                $display("PASS");
                $display("  Outputs: shift_0=%b, shift_15=%b",
                         shift_0, shift_15);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_0=%b, shift_15=%b",
                         expected_shift_0, expected_shift_15);
                $display("  Got:      shift_0=%b, shift_15=%b",
                         shift_0, shift_15);
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
        $dumpvars(0,brg_en, clk, rst, rx_in, shift_0, shift_15);
    end

endmodule
