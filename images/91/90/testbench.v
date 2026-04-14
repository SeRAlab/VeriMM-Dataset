`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] d;
    wire [23:0] c;
    wire [11:0] d_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .c(c),
        .d_(d_)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros - Checking basic encoding/decoding", test_num);
        d = 12'h000;


        #10;
        #1;

        check_outputs(24'h000000, 12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones - Checking signal saturation", test_num);
        d = 12'hFFF;
        #10;



        #1;




        check_outputs(24'hFFF000, 12'hFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Pattern 1 (AAA)", test_num);
        d = 12'hAAA;
        #10;
        #1;

        check_outputs(24'hAAA000, 12'hAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Pattern 2 (555)", test_num);
        d = 12'h555;
        #10;
        #1;

        check_outputs(24'h555000, 12'h555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit Set (MSB)", test_num);
        d = 12'h800;
        #10;
        #1;

        check_outputs(24'h800000, 12'h800);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit Set (LSB)", test_num);
        d = 12'h001;
        #10;
        #1;

        check_outputs(24'h001000, 12'h001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Walking Bit Pattern", test_num);
        d = 12'h010;
        #10;
        #1;

        check_outputs(24'h010000, 12'h010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random Data Pattern (123)", test_num);
        d = 12'h123;
        #10;
        #1;

        check_outputs(24'h123000, 12'h123);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random Data Pattern (C39)", test_num);
        d = 12'hC39;
        #10;
        #1;

        check_outputs(24'hC39000, 12'hC39);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Inverse Alternating Pattern (F0F)", test_num);
        d = 12'hF0F;
        #10;
        #1;

        check_outputs(24'hF0F000, 12'hF0F);
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
        input [23:0] expected_c;
        input [11:0] expected_d_;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_d_ === (expected_d_ ^ d_ ^ expected_d_)) begin
                $display("PASS");
                $display("  Outputs: c=%h, d_=%h",
                         c, d_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h, d_=%h",
                         expected_c, expected_d_);
                $display("  Got:      c=%h, d_=%h",
                         c, d_);
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
