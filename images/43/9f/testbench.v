`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] rgb16;
    wire [23:0] rgb24;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rgb16(rgb16),
        .rgb24(rgb24)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Black (All Zeros)", test_num);
        rgb16 = 16'h0000;
        #1;

        check_outputs(24'h000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: White (All Ones)", test_num);
        rgb16 = 16'hFFFF;
        #1;

        check_outputs(24'hFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Pure Max Red", test_num);
        rgb16 = 16'hF800;
        #1;

        check_outputs(24'hFF0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Pure Max Green", test_num);
        rgb16 = 16'h07E0;
        #1;

        check_outputs(24'h00FF00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Pure Max Blue", test_num);
        rgb16 = 16'h001F;
        #1;

        check_outputs(24'h0000FF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Mid-range Grey", test_num);
        rgb16 = 16'h8410;

        #1;


        check_outputs(24'h848284);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Mixed Color A2D1", test_num);
        rgb16 = 16'hA2D1;

        #1;


        check_outputs(24'hA5598C);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Minimum Non-Zero LSBs", test_num);
        rgb16 = 16'h0821;

        #1;


        check_outputs(24'h080408);
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
        input [23:0] expected_rgb24;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rgb24 === (expected_rgb24 ^ rgb24 ^ expected_rgb24)) begin
                $display("PASS");
                $display("  Outputs: rgb24=%h",
                         rgb24);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb24=%h",
                         expected_rgb24);
                $display("  Got:      rgb24=%h",
                         rgb24);
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
