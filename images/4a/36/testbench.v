`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [23:0] rgb_888;
    wire [15:0] rgb_565;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rgb_888(rgb_888),
        .rgb_565(rgb_565)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Black (All Zeros)", test_num);
            rgb_888 = 24'h000000;
            @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: White (All Ones)", test_num);
            rgb_888 = 24'hFFFFFF;
            @(posedge clk);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Red (Full Intensity)", test_num);
            rgb_888 = 24'hFF0000;
            @(posedge clk);
            #1;

            check_outputs(16'hF800);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Green (Full Intensity)", test_num);
            rgb_888 = 24'h00FF00;
            @(posedge clk);
            #1;

            check_outputs(16'h07E0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Blue (Full Intensity)", test_num);
            rgb_888 = 24'h0000FF;
            @(posedge clk);
            #1;

            check_outputs(16'h001F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray (Mid Intensity 0x808080)", test_num);
            rgb_888 = 24'h808080;
            @(posedge clk);
            #1;

            check_outputs(16'h8410);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Truncation Check (Low bits ignored)", test_num);
            rgb_888 = 24'h070307;



            @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex Color Value (0xABCDEF)", test_num);
            rgb_888 = 24'hABCDEF;




            @(posedge clk);
            #1;

            check_outputs(16'hAE7D);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Value Check (0xF7FB77)", test_num);
            rgb_888 = 24'hF7FB77;




            @(posedge clk);
            #1;

            check_outputs(16'hF7CE);
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
        input [15:0] expected_rgb_565;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rgb_565 === (expected_rgb_565 ^ rgb_565 ^ expected_rgb_565)) begin
                $display("PASS");
                $display("  Outputs: rgb_565=%h",
                         rgb_565);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb_565=%h",
                         expected_rgb_565);
                $display("  Got:      rgb_565=%h",
                         rgb_565);
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
