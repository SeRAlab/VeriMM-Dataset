`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg raster_int_in_progress;
    reg rst_n;
    reg [7:0] zxuno_addr;
    reg zxuno_regrd;
    reg zxuno_regwr;
    wire [7:0] dout;
    wire oe_n;
    wire [8:0] raster_line;
    wire rasterint_enable;
    wire vretraceint_disable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .raster_int_in_progress(raster_int_in_progress),
        .rst_n(rst_n),
        .zxuno_addr(zxuno_addr),
        .zxuno_regrd(zxuno_regrd),
        .zxuno_regwr(zxuno_regwr),
        .dout(dout),
        .oe_n(oe_n),
        .raster_line(raster_line),
        .rasterint_enable(rasterint_enable),
        .vretraceint_disable(vretraceint_disable)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            din = 0;
            raster_int_in_progress = 0;
            zxuno_addr = 0;
            zxuno_regrd = 0;
            zxuno_regwr = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset state", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 9'h000, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Write Raster Line Low Byte", test_num);
            reset_dut();
            @(posedge clk);
            zxuno_addr = 8'h23;
            din = 8'hC8;
            zxuno_regwr = 1;
            @(posedge clk);
            zxuno_regwr = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b1, 9'h0C8, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Write MSB and Enable Bits", test_num);
            reset_dut();

            zxuno_addr = 8'h23; din = 8'h55; zxuno_regwr = 1; @(posedge clk);

            zxuno_addr = 8'h24; din = 8'h03; zxuno_regwr = 1; @(posedge clk);
            zxuno_regwr = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b1, 9'h155, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Read Register and Status bit", test_num);
            reset_dut();
            raster_int_in_progress = 1;
            zxuno_addr = 8'h23;
            zxuno_regrd = 1;
            @(posedge clk);


            #1;



            check_outputs(8'h80, 1'b0, 9'h000, 1'b0, 1'b0);
            zxuno_regrd = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Full Config with V-Retrace Disable", test_num);
            reset_dut();

            zxuno_addr = 8'h23; din = 8'hFF; zxuno_regwr = 1; @(posedge clk);

            zxuno_addr = 8'h24; din = 8'h07; zxuno_regwr = 1; @(posedge clk);
            zxuno_regwr = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b1, 9'h1FF, 1'b1, 1'b1);
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
        input [7:0] expected_dout;
        input expected_oe_n;
        input [8:0] expected_raster_line;
        input expected_rasterint_enable;
        input expected_vretraceint_disable;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_oe_n === (expected_oe_n ^ oe_n ^ expected_oe_n) &&
                expected_raster_line === (expected_raster_line ^ raster_line ^ expected_raster_line) &&
                expected_rasterint_enable === (expected_rasterint_enable ^ rasterint_enable ^ expected_rasterint_enable) &&
                expected_vretraceint_disable === (expected_vretraceint_disable ^ vretraceint_disable ^ expected_vretraceint_disable)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, oe_n=%b, raster_line=%h, rasterint_enable=%b, vretraceint_disable=%b",
                         dout, oe_n, raster_line, rasterint_enable, vretraceint_disable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, oe_n=%b, raster_line=%h, rasterint_enable=%b, vretraceint_disable=%b",
                         expected_dout, expected_oe_n, expected_raster_line, expected_rasterint_enable, expected_vretraceint_disable);
                $display("  Got:      dout=%h, oe_n=%b, raster_line=%h, rasterint_enable=%b, vretraceint_disable=%b",
                         dout, oe_n, raster_line, rasterint_enable, vretraceint_disable);
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
        $dumpvars(0,clk, din, raster_int_in_progress, rst_n, zxuno_addr, zxuno_regrd, zxuno_regwr, dout, oe_n, raster_line, rasterint_enable, vretraceint_disable);
    end

endmodule
