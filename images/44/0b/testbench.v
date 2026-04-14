`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg hblank;
    reg [9:0] hcount;
    reg rst;
    reg vblank;
    reg [9:0] vcount;
    wire [4:0] blue;
    wire [5:0] green;
    wire [4:0] red;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hblank(hblank),
        .hcount(hcount),
        .rst(rst),
        .vblank(vblank),
        .vcount(vcount),
        .blue(blue),
        .green(green),
        .red(red)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset State", test_num);
        rst = 1;
        hcount = 0; vcount = 0; hblank = 0; vblank = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(5'h00, 6'h00, 5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Red Range Start (hcount=0)", test_num);
        rst = 0;
        hcount = 10'd0; vcount = 10'd0; hblank = 0; vblank = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h00, 6'h00, 5'h1F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Red Range End (hcount=212)", test_num);
        rst = 0;
        hcount = 10'd212; vcount = 10'd0; hblank = 0; vblank = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h00, 6'h00, 5'h1F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Blue Range Start (hcount=213)", test_num);
        rst = 0;
        hcount = 10'd213; vcount = 10'd0; hblank = 0; vblank = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h1F, 6'h00, 5'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Blue Range End (hcount=600)", test_num);
        rst = 0;
        hcount = 10'd600; vcount = 10'd0; hblank = 0; vblank = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h1F, 6'h00, 5'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Green Range Start (hcount=601)", test_num);
        rst = 0;
        hcount = 10'd601; vcount = 10'd0; hblank = 0; vblank = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h00, 6'h3F, 5'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Green Range End (hcount=639)", test_num);
        rst = 0;
        hcount = 10'd639; vcount = 10'd0; hblank = 0; vblank = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h00, 6'h3F, 5'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Out of range (hcount=640)", test_num);
        rst = 0;
        hcount = 10'd640; vcount = 10'd0; hblank = 0; vblank = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h00, 6'h00, 5'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: H-Blanking Active", test_num);
        rst = 0;
        hcount = 10'd100; vcount = 10'd0; hblank = 1; vblank = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h00, 6'h00, 5'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: V-Blanking Active", test_num);
        rst = 0;
        hcount = 10'd400; vcount = 10'd0; hblank = 0; vblank = 1;
        @(posedge clk);
        #1;

        check_outputs(5'h00, 6'h00, 5'h00);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Blue Range Mid (hcount=400)", test_num);
        rst = 0;
        hcount = 10'd400; vcount = 10'd100; hblank = 0; vblank = 0;
        @(posedge clk);
        #1;

        check_outputs(5'h1F, 6'h00, 5'h00);
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
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input [4:0] expected_blue;
        input [5:0] expected_green;
        input [4:0] expected_red;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_blue === (expected_blue ^ blue ^ expected_blue) &&
                expected_green === (expected_green ^ green ^ expected_green) &&
                expected_red === (expected_red ^ red ^ expected_red)) begin
                $display("PASS");
                $display("  Outputs: blue=%h, green=%h, red=%h",
                         blue, green, red);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blue=%h, green=%h, red=%h",
                         expected_blue, expected_green, expected_red);
                $display("  Got:      blue=%h, green=%h, red=%h",
                         blue, green, red);
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
