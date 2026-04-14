`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_25;
    reg [9:0] xaddr;
    reg [9:0] yaddr;
    wire [23:0] rgb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_25(clk_25),
        .xaddr(xaddr),
        .yaddr(yaddr),
        .rgb(rgb)
    );

    // Clock generation (10ns period)
    initial begin
        clk_25 = 0;
        forever #5 clk_25 = ~clk_25;
    end

        task reset_dut;

        begin
            xaddr <= 0;
            yaddr <= 0;
            repeat(10) @(posedge clk_25);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Processing Origin (0,0)", test_num);
            reset_dut();

            xaddr <= 10'd0;
            yaddr <= 10'd0;


            repeat(16) @(posedge clk_25);



            #1;




            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Mid-line pixel (100, 0)", test_num);
            reset_dut();


            for (integer i = 0; i <= 100; i = i + 1) begin
                xaddr <= i;
                yaddr <= 10'd0;
                @(posedge clk_25);
            end


            repeat(5) @(posedge clk_25);
            #1;

            check_outputs(24'hFF0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Horizontal line transition (Line 0 to Line 1)", test_num);
            reset_dut();


            xaddr <= 10'd639;
            yaddr <= 10'd0;
            repeat(5) @(posedge clk_25);


            xaddr <= 10'd0;
            yaddr <= 10'd1;
            repeat(10) @(posedge clk_25);

            #1;


            check_outputs(24'h00FF00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Center screen pixel (320, 240)", test_num);
            reset_dut();

            xaddr <= 10'd320;
            yaddr <= 10'd240;


            repeat(32) @(posedge clk_25);

            #1;


            check_outputs(24'h0000FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: End of frame boundary (639, 479)", test_num);
            reset_dut();

            xaddr <= 10'd639;
            yaddr <= 10'd479;

            repeat(20) @(posedge clk_25);

            #1;


            check_outputs(24'hABCDEF);
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
        input [23:0] expected_rgb;
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
        $dumpvars(0,clk_25, xaddr, yaddr, rgb);
    end

endmodule
