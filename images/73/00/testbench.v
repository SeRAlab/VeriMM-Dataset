`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [18:0] i_0;
    reg [18:0] i_1;
    reg [18:0] i_2;
    reg [18:0] i_3;
    wire [18:0] o_0;
    wire [18:0] o_1;
    wire [18:0] o_2;
    wire [18:0] o_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_0(i_0),
        .i_1(i_1),
        .i_2(i_2),
        .i_3(i_3),
        .o_0(o_0),
        .o_1(o_1),
        .o_2(o_2),
        .o_3(o_3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic routing check with distinct values", test_num);

        i_0 = 19'h00001;
        i_1 = 19'h00002;
        i_2 = 19'h00003;
        i_3 = 19'h00004;
        #1;

        check_outputs(19'h00001, 19'h00003, 19'h00002, 19'h00004);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All zeros", test_num);
        i_0 = 19'h00000;
        i_1 = 19'h00000;
        i_2 = 19'h00000;
        i_3 = 19'h00000;
        #1;

        check_outputs(19'h00000, 19'h00000, 19'h00000, 19'h00000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Signed Maximum and Minimum values", test_num);

        i_0 = 19'h3FFFF;
        i_1 = 19'h40000;
        i_2 = 19'h7FFFF;
        i_3 = 19'h00000;
        #1;

        check_outputs(19'h3FFFF, 19'h7FFFF, 19'h40000, 19'h00000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bit patterns", test_num);
        i_0 = 19'h55555;
        i_1 = 19'h2AAAA;
        i_2 = 19'h70F0F;
        i_3 = 19'h0F0F0;
        #1;

        check_outputs(19'h55555, 19'h70F0F, 19'h2AAAA, 19'h0F0F0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identical inputs", test_num);
        i_0 = 19'h12345;
        i_1 = 19'h12345;
        i_2 = 19'h12345;
        i_3 = 19'h12345;
        #1;

        check_outputs(19'h12345, 19'h12345, 19'h12345, 19'h12345);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary values check (Single bit high)", test_num);
        i_0 = 19'h00001;
        i_1 = 19'h00002;
        i_2 = 19'h00004;
        i_3 = 19'h00008;
        #1;

        check_outputs(19'h00001, 19'h00004, 19'h00002, 19'h00008);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Edge case (Highest bits)", test_num);
        i_0 = 19'h40001;
        i_1 = 19'h20000;
        i_2 = 19'h1FFFF;
        i_3 = 19'h60000;
        #1;

        check_outputs(19'h40001, 19'h1FFFF, 19'h20000, 19'h60000);
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
        input [18:0] expected_o_0;
        input [18:0] expected_o_1;
        input [18:0] expected_o_2;
        input [18:0] expected_o_3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_0 === (expected_o_0 ^ o_0 ^ expected_o_0) &&
                expected_o_1 === (expected_o_1 ^ o_1 ^ expected_o_1) &&
                expected_o_2 === (expected_o_2 ^ o_2 ^ expected_o_2) &&
                expected_o_3 === (expected_o_3 ^ o_3 ^ expected_o_3)) begin
                $display("PASS");
                $display("  Outputs: o_0=%h, o_1=%h, o_2=%h, o_3=%h",
                         o_0, o_1, o_2, o_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_0=%h, o_1=%h, o_2=%h, o_3=%h",
                         expected_o_0, expected_o_1, expected_o_2, expected_o_3);
                $display("  Got:      o_0=%h, o_1=%h, o_2=%h, o_3=%h",
                         o_0, o_1, o_2, o_3);
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
