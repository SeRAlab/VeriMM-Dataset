`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg en;
    reg [9:0] h_cnt;
    reg rst;
    reg [9:0] v_cnt;
    wire [16:0] pixel_addr;
    wire [16:0] pixel_addr_red;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir(dir),
        .en(en),
        .h_cnt(h_cnt),
        .rst(rst),
        .v_cnt(v_cnt),
        .pixel_addr(pixel_addr),
        .pixel_addr_red(pixel_addr_red)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            dir = 0;
            h_cnt = 0;
            v_cnt = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            h_cnt = 10;
            v_cnt = 5;
            #1;

            check_outputs(1610, 1610);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            en = 1;
            dir = 1;
            repeat(5) @(posedge clk);
            #2 en = 0;
            h_cnt = 0;
            v_cnt = 0;
            #1;

            check_outputs(0, 5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            en = 1;
            dir = 1;
            repeat(10) @(posedge clk);
            dir = 0;
            repeat(3) @(posedge clk);
            #2 en = 0;
            h_cnt = 100;
            v_cnt = 20;
            #1;

            check_outputs(6500, 6507);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            h_cnt = 319;
            v_cnt = 239;
            #1;

            check_outputs(76799, 76799);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            en = 1;
            dir = 1;
            repeat(50) @(posedge clk);
            #2 en = 0;
            h_cnt = 50;
            v_cnt = 50;
            #1;

            check_outputs(16050, 16100);
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
        input [16:0] expected_pixel_addr;
        input [16:0] expected_pixel_addr_red;
        begin
            if (expected_pixel_addr === (expected_pixel_addr ^ pixel_addr ^ expected_pixel_addr) &&
                expected_pixel_addr_red === (expected_pixel_addr_red ^ pixel_addr_red ^ expected_pixel_addr_red)) begin
                $display("PASS");
                $display("  Outputs: pixel_addr=%h, pixel_addr_red=%h",
                         pixel_addr, pixel_addr_red);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel_addr=%h, pixel_addr_red=%h",
                         expected_pixel_addr, expected_pixel_addr_red);
                $display("  Got:      pixel_addr=%h, pixel_addr_red=%h",
                         pixel_addr, pixel_addr_red);
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
        $dumpvars(0,clk, dir, en, h_cnt, rst, v_cnt, pixel_addr, pixel_addr_red);
    end

endmodule
