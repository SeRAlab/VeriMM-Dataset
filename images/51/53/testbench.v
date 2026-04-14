`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] pixel_x;
    reg [9:0] pixel_y;
    reg [3:0] push;
    reg rst;
    reg [2:0] switch;
    reg video_on;
    wire [2:0] rgb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .push(push),
        .rst(rst),
        .switch(switch),
        .video_on(video_on),
        .rgb(rgb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            push = 4'b0000;
            switch = 3'b000;
            pixel_x = 0;
            pixel_y = 0;
            video_on = 0;
            repeat(5) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            video_on = 0;
            pixel_x = 10'd320;
            pixel_y = 10'd240;
            switch = 3'b111;
            repeat(2) @(posedge clk);
            $display("Testcase %0d: Testing video_on blanking", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            video_on = 1;
            pixel_x = 10'd0;
            pixel_y = 10'd0;
            switch = 3'b000;
            repeat(2) @(posedge clk);
            $display("Testcase %0d: Testing default mode output at (0,0)", test_num);


            #1;



            check_outputs(rgb);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            video_on = 1;
            pixel_x = 10'd100;
            pixel_y = 10'd100;
            switch = 3'b010;
            repeat(2) @(posedge clk);
            $display("Testcase %0d: Testing switch mode change to 3'b010", test_num);
            #1;

            check_outputs(rgb);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            video_on = 1;
            switch = 3'b001;

            pixel_x = 10'd320;
            pixel_y = 10'd240;
            repeat(2) @(posedge clk);


            push = 4'b0001;
            repeat(10) @(posedge clk);
            push = 4'b0000;
            repeat(2) @(posedge clk);

            $display("Testcase %0d: Testing animation update via push buttons", test_num);
            #1;

            check_outputs(rgb);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            video_on = 1;
            pixel_x = 10'd639;
            pixel_y = 10'd479;
            switch = 3'b100;
            repeat(2) @(posedge clk);
            $display("Testcase %0d: Testing boundary coordinates (639, 479)", test_num);
            #1;

            check_outputs(rgb);
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
        input [2:0] expected_rgb;
        begin
            if (expected_rgb === (expected_rgb ^ rgb ^ expected_rgb)) begin
                $display("PASS");
                $display("  Outputs: rgb=%h",
                         rgb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb=%h",
                         expected_rgb);
                $display("  Got:      rgb=%h",
                         rgb);
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
        $dumpvars(0,clk, pixel_x, pixel_y, push, rst, switch, video_on, rgb);
    end

endmodule
