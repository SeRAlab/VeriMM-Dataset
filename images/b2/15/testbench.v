`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg discard_pixel;
    reg fail_z_check;
    reg rst_i;
    reg write_i;
    reg z_ack_i;
    reg zbuffer_enable_i;
    wire ack_o;
    wire write_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .discard_pixel(discard_pixel),
        .fail_z_check(fail_z_check),
        .rst_i(rst_i),
        .write_i(write_i),
        .z_ack_i(z_ack_i),
        .zbuffer_enable_i(zbuffer_enable_i),
        .ack_o(ack_o),
        .write_o(write_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            write_i = 0;
            discard_pixel = 0;
            zbuffer_enable_i = 0;
            z_ack_i = 0;
            fail_z_check = 0;
            repeat(2) @(posedge clk_i);
            #1 rst_i = 0;
            repeat(1) @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Direct Pixel Write (Z-buffer disabled)", test_num);

            write_i = 1;
            zbuffer_enable_i = 0;


            while (!ack_o) @(posedge clk_i);
            #1;

            #1;


            check_outputs(1, 0);

            write_i = 0;
            @(posedge clk_i);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Z-buffer enabled, Z-check Pass", test_num);

            write_i = 1;
            zbuffer_enable_i = 1;


            @(posedge clk_i);
            #1;


            z_ack_i = 1;
            fail_z_check = 0;


            while (!ack_o) @(posedge clk_i);
            #1;

            #1;


            check_outputs(1, 0);

            write_i = 0;
            z_ack_i = 0;
            @(posedge clk_i);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Z-buffer enabled, Z-check Fail", test_num);

            write_i = 1;
            zbuffer_enable_i = 1;

            @(posedge clk_i);
            #1;

            z_ack_i = 1;
            fail_z_check = 1;

            while (!ack_o) @(posedge clk_i);
            #1;

            #1;


            check_outputs(1, 0);

            write_i = 0;
            z_ack_i = 0;
            fail_z_check = 0;
            @(posedge clk_i);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Discard Pixel Active", test_num);

            write_i = 1;
            discard_pixel = 1;

            while (!ack_o) @(posedge clk_i);
            #1;

            #1;


            check_outputs(1, 0);

            write_i = 0;
            discard_pixel = 0;
            @(posedge clk_i);
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
        input expected_ack_o;
        input expected_write_o;
        begin
            if (expected_ack_o === (expected_ack_o ^ ack_o ^ expected_ack_o) &&
                expected_write_o === (expected_write_o ^ write_o ^ expected_write_o)) begin
                $display("PASS");
                $display("  Outputs: ack_o=%b, write_o=%b",
                         ack_o, write_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_o=%b, write_o=%b",
                         expected_ack_o, expected_write_o);
                $display("  Got:      ack_o=%b, write_o=%b",
                         ack_o, write_o);
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
        $dumpvars(0,clk_i, discard_pixel, fail_z_check, rst_i, write_i, z_ack_i, zbuffer_enable_i, ack_o, write_o);
    end

endmodule
