`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] i;
    wire [7:0] o0;
    wire [7:0] o1;
    wire [7:0] o2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .o0(o0),
        .o1(o1),
        .o2(o2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            i = 24'h000000;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            i = 24'hFFFFFF;
            #1;

            check_outputs(8'hFF, 8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Hex Pattern", test_num);
            i = 24'h123456;
            #1;

            check_outputs(8'h56, 8'h34, 8'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alphabetical Hex Pattern", test_num);
            i = 24'hABCDEF;
            #1;

            check_outputs(8'hEF, 8'hCD, 8'hAB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (0101...)", test_num);
            i = 24'h555555;
            #1;

            check_outputs(8'h55, 8'h55, 8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (1010...)", test_num);
            i = 24'hAAAAAA;
            #1;

            check_outputs(8'hAA, 8'hAA, 8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Byte isolation (o2 high)", test_num);
            i = 24'hFF0000;
            #1;

            check_outputs(8'h00, 8'h00, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Byte isolation (o1 high)", test_num);
            i = 24'h00FF00;
            #1;

            check_outputs(8'h00, 8'hFF, 8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Byte isolation (o0 high)", test_num);
            i = 24'h0000FF;
            #1;

            check_outputs(8'hFF, 8'h00, 8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed High-Low bytes", test_num);
            i = 24'hA5005A;
            #1;

            check_outputs(8'h5A, 8'h00, 8'hA5);
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
        input [7:0] expected_o0;
        input [7:0] expected_o1;
        input [7:0] expected_o2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2)) begin
                $display("PASS");
                $display("  Outputs: o0=%h, o1=%h, o2=%h",
                         o0, o1, o2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%h, o1=%h, o2=%h",
                         expected_o0, expected_o1, expected_o2);
                $display("  Got:      o0=%h, o1=%h, o2=%h",
                         o0, o1, o2);
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
