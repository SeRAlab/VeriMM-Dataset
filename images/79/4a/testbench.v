`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] din;
    reg [9:0] pixel_x;
    reg [9:0] pixel_y;
    reg reset;
    wire [18:0] addr_r;
    wire [7:0] px_rgb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .reset(reset),
        .addr_r(addr_r),
        .px_rgb(px_rgb)
    );
    task perform_reset;

    begin
        reset = 1;
        pixel_x = 0;
        pixel_y = 0;
        din = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        perform_reset();
        pixel_x = 10'd0;
        pixel_y = 10'd0;
        din = 32'hAABBCCDD;
        @(posedge clk);

        #1;


        check_outputs(19'h0, 8'hDD);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        perform_reset();
        pixel_x = 10'd1;
        pixel_y = 10'd0;
        din = 32'hAABBCCDD;
        @(posedge clk);

        #1;


        check_outputs(19'h0, 8'hCC);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        perform_reset();
        pixel_x = 10'd2;
        pixel_y = 10'd0;
        din = 32'h12345678;
        @(posedge clk);

        #1;


        check_outputs(19'h0, 8'h34);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        perform_reset();
        pixel_x = 10'd3;
        pixel_y = 10'd0;
        din = 32'h12345678;
        @(posedge clk);

        #1;


        check_outputs(19'h0, 8'h12);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        perform_reset();
        pixel_x = 10'd4;
        pixel_y = 10'd0;
        din = 32'hAAAA_BBBB;
        @(posedge clk);

        #1;


        check_outputs(19'h1, 8'hBB);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        perform_reset();
        pixel_x = 10'd0;
        pixel_y = 10'd1;
        din = 32'hFFEE_DDCC;
        @(posedge clk);

        #1;


        check_outputs(19'd160, 8'hCC);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        perform_reset();
        pixel_x = 10'd640;
        pixel_y = 10'd10;
        din = 32'hFFFF_FFFF;
        @(posedge clk);

        #1;


        check_outputs(19'd1600, 8'h00);
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
        testcase007();
        
        
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
        input [18:0] expected_addr_r;
        input [7:0] expected_px_rgb;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addr_r === (expected_addr_r ^ addr_r ^ expected_addr_r) &&
                expected_px_rgb === (expected_px_rgb ^ px_rgb ^ expected_px_rgb)) begin
                $display("PASS");
                $display("  Outputs: addr_r=%h, px_rgb=%h",
                         addr_r, px_rgb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_r=%h, px_rgb=%h",
                         expected_addr_r, expected_px_rgb);
                $display("  Got:      addr_r=%h, px_rgb=%h",
                         addr_r, px_rgb);
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
