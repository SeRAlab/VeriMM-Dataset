`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [15:0] rgb_565;
    wire [23:0] rgb_888;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rgb_565(rgb_565),
        .rgb_888(rgb_888)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Black (0x0000)", test_num);
        rgb_565 = 16'h0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'h000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All White (0xFFFF)", test_num);
        rgb_565 = 16'hFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'hF8FCF8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pure Red (0xF800)", test_num);
        rgb_565 = 16'hF800;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'hF80000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pure Green (0x07E0)", test_num);
        rgb_565 = 16'h07E0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'h00FC00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pure Blue (0x001F)", test_num);
        rgb_565 = 16'h001F;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'h0000F8);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Color Mix (0xABCD)", test_num);
        rgb_565 = 16'hABCD;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'hA87868);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Color Mix (0x1234)", test_num);
        rgb_565 = 16'h1234;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'h1044A0);
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
        input [23:0] expected_rgb_888;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rgb_888 === (expected_rgb_888 ^ rgb_888 ^ expected_rgb_888)) begin
                $display("PASS");
                $display("  Outputs: rgb_888=%h",
                         rgb_888);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb_888=%h",
                         expected_rgb_888);
                $display("  Got:      rgb_888=%h",
                         rgb_888);
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
