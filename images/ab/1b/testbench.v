`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg RST_N;
    wire RDY_hsync;
    wire RDY_pixelect;
    wire RDY_stack_en;
    wire RDY_video_en;
    wire RDY_vsync;
    wire hsync;
    wire [16:0] pixelect;
    wire stack_en;
    wire video_en;
    wire vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST_N(RST_N),
        .RDY_hsync(RDY_hsync),
        .RDY_pixelect(RDY_pixelect),
        .RDY_stack_en(RDY_stack_en),
        .RDY_video_en(RDY_video_en),
        .RDY_vsync(RDY_vsync),
        .hsync(hsync),
        .pixelect(pixelect),
        .stack_en(stack_en),
        .video_en(video_en),
        .vsync(vsync)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Power-on Reset and Initial State Check", test_num);

            RST_N = 0;
            #20;
            RST_N = 1;

            @(posedge CLK);
            #1;




            #1;





            check_outputs(1, 1, 1, 1, 1, 1, 17'h0, 1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stability Check Over Multiple Cycles", test_num);


            repeat(20) @(posedge CLK);


            #1;



            check_outputs(1, 1, 1, 1, 1, 1, 17'h0, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-Operation Reset Recovery", test_num);


            RST_N = 0;
            repeat(2) @(posedge CLK);
            RST_N = 1;


            repeat(5) @(posedge CLK);


            #1;



            check_outputs(1, 1, 1, 1, 1, 1, 17'h0, 1, 1, 1);
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
        input expected_RDY_hsync;
        input expected_RDY_pixelect;
        input expected_RDY_stack_en;
        input expected_RDY_video_en;
        input expected_RDY_vsync;
        input expected_hsync;
        input [16:0] expected_pixelect;
        input expected_stack_en;
        input expected_video_en;
        input expected_vsync;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RDY_hsync === (expected_RDY_hsync ^ RDY_hsync ^ expected_RDY_hsync) &&
                expected_RDY_pixelect === (expected_RDY_pixelect ^ RDY_pixelect ^ expected_RDY_pixelect) &&
                expected_RDY_stack_en === (expected_RDY_stack_en ^ RDY_stack_en ^ expected_RDY_stack_en) &&
                expected_RDY_video_en === (expected_RDY_video_en ^ RDY_video_en ^ expected_RDY_video_en) &&
                expected_RDY_vsync === (expected_RDY_vsync ^ RDY_vsync ^ expected_RDY_vsync) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_pixelect === (expected_pixelect ^ pixelect ^ expected_pixelect) &&
                expected_stack_en === (expected_stack_en ^ stack_en ^ expected_stack_en) &&
                expected_video_en === (expected_video_en ^ video_en ^ expected_video_en) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: RDY_hsync=%b, RDY_pixelect=%b, RDY_stack_en=%b, RDY_video_en=%b, RDY_vsync=%b, hsync=%b, pixelect=%h, stack_en=%b, video_en=%b, vsync=%b",
                         RDY_hsync, RDY_pixelect, RDY_stack_en, RDY_video_en, RDY_vsync, hsync, pixelect, stack_en, video_en, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RDY_hsync=%b, RDY_pixelect=%b, RDY_stack_en=%b, RDY_video_en=%b, RDY_vsync=%b, hsync=%b, pixelect=%h, stack_en=%b, video_en=%b, vsync=%b",
                         expected_RDY_hsync, expected_RDY_pixelect, expected_RDY_stack_en, expected_RDY_video_en, expected_RDY_vsync, expected_hsync, expected_pixelect, expected_stack_en, expected_video_en, expected_vsync);
                $display("  Got:      RDY_hsync=%b, RDY_pixelect=%b, RDY_stack_en=%b, RDY_video_en=%b, RDY_vsync=%b, hsync=%b, pixelect=%h, stack_en=%b, video_en=%b, vsync=%b",
                         RDY_hsync, RDY_pixelect, RDY_stack_en, RDY_video_en, RDY_vsync, hsync, pixelect, stack_en, video_en, vsync);
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

endmodule
