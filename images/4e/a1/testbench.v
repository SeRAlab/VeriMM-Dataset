`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] d_i;
    reg href_i;
    reg pclk_i;
    reg rst_i;
    reg vsync_i;
    wire pixelReady_o;
    wire [15:0] pixel_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d_i(d_i),
        .href_i(href_i),
        .pclk_i(pclk_i),
        .rst_i(rst_i),
        .vsync_i(vsync_i),
        .pixelReady_o(pixelReady_o),
        .pixel_o(pixel_o)
    );

    // Clock generation (10ns period)
    initial begin
        pclk_i = 0;
        forever #5 pclk_i = ~pclk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            d_i = 8'h00;
            href_i = 0;
            vsync_i = 0;
            @(negedge pclk_i);
            rst_i = 0;
            @(negedge pclk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Single Pixel Capture", test_num);
            reset_dut();

            @(negedge pclk_i);
            href_i = 1;
            d_i = 8'hAA;
            @(negedge pclk_i);
            d_i = 8'hBB;

            @(posedge pclk_i);
            #1;
            #1;

            check_outputs(1'b1, 16'hAABB);

            @(negedge pclk_i);
            href_i = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Multiple Pixel Capture", test_num);
            reset_dut();

            @(negedge pclk_i);
            href_i = 1;


            d_i = 8'h12; @(negedge pclk_i);
            d_i = 8'h34; @(negedge pclk_i);


            d_i = 8'h56; @(negedge pclk_i);
            d_i = 8'h78; @(negedge pclk_i);

            @(posedge pclk_i);
            #1;
            #1;

            check_outputs(1'b1, 16'h5678);

            @(negedge pclk_i);
            href_i = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: VSync Reset Mid-transfer", test_num);
            reset_dut();

            @(negedge pclk_i);
            href_i = 1;
            d_i = 8'hEE;
            @(negedge pclk_i);
            vsync_i = 1;
            href_i = 0;
            @(negedge pclk_i);
            vsync_i = 0;
            href_i = 1;
            d_i = 8'h11;
            @(negedge pclk_i);
            d_i = 8'h22;

            @(posedge pclk_i);
            #1;
            #1;

            check_outputs(1'b1, 16'h1122);

            @(negedge pclk_i);
            href_i = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: HREF Inactive Between Bytes", test_num);
            reset_dut();

            @(negedge pclk_i);
            href_i = 1;
            d_i = 8'hDE;
            @(negedge pclk_i);
            href_i = 0;
            d_i = 8'h00;
            @(negedge pclk_i);
            href_i = 1;
            d_i = 8'hAD;

            @(posedge pclk_i);
            #1;




            #1;





            check_outputs(1'b1, 16'hDEAD);

            @(negedge pclk_i);
            href_i = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Extremes (All 0s and 1s)", test_num);
            reset_dut();

            @(negedge pclk_i);
            href_i = 1;
            d_i = 8'hFF; @(negedge pclk_i);
            d_i = 8'hFF; @(negedge pclk_i);

            @(posedge pclk_i);
            #1;
            #1;

            check_outputs(1'b1, 16'hFFFF);

            @(negedge pclk_i);
            d_i = 8'h00; @(negedge pclk_i);
            d_i = 8'h00; @(negedge pclk_i);

            @(posedge pclk_i);
            #1;
            #1;

            check_outputs(1'b1, 16'h0000);

            @(negedge pclk_i);
            href_i = 0;
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
        input expected_pixelReady_o;
        input [15:0] expected_pixel_o;
        begin
            if (expected_pixelReady_o === (expected_pixelReady_o ^ pixelReady_o ^ expected_pixelReady_o) &&
                expected_pixel_o === (expected_pixel_o ^ pixel_o ^ expected_pixel_o)) begin
                $display("PASS");
                $display("  Outputs: pixelReady_o=%b, pixel_o=%h",
                         pixelReady_o, pixel_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixelReady_o=%b, pixel_o=%h",
                         expected_pixelReady_o, expected_pixel_o);
                $display("  Got:      pixelReady_o=%b, pixel_o=%h",
                         pixelReady_o, pixel_o);
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
        $dumpvars(0,d_i, href_i, pclk_i, rst_i, vsync_i, pixelReady_o, pixel_o);
    end

endmodule
