`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire [63:0] left;
    wire [63:0] right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .left(left),
        .right(right)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Shift", test_num);
        A = 64'hFEDCBA9876543210;
        B = 64'h0000000000000000;
        #1;

        check_outputs(64'hFEDCBA9876543210, 64'hFEDCBA9876543210);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift by 1 bit", test_num);
        A = 64'h8000000000000001;
        B = 64'h0000000000000001;

        #1;


        check_outputs(64'h0000000000000002, 64'h4000000000000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift by 4 bits", test_num);
        A = 64'h123456789ABCDEF0;
        B = 64'd4;
        #1;

        check_outputs(64'h23456789ABCDEF00, 64'h0123456789ABCDEF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift by 32 bits", test_num);
        A = 64'hFFFFFFFF00000000;
        B = 64'd32;
        #1;

        check_outputs(64'h0000000000000000, 64'h00000000FFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Shift (63 bits)", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'd63;
        #1;

        check_outputs(64'h8000000000000000, 64'h0000000000000001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift amount > 63 (B=65, B[5:0]=1)", test_num);
        A = 64'h000000000000000F;
        B = 64'd65;
        #1;

        check_outputs(64'h000000000000001E, 64'h0000000000000007);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A is zero", test_num);
        A = 64'h0000000000000000;
        B = 64'd31;
        #1;

        check_outputs(64'h0, 64'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Ignoring upper bits of B", test_num);
        A = 64'hAAAAAAAAA5555555;
        B = 64'hFFFFFFFFFFFFFFC2;

        #1;


        check_outputs(64'hAAAAAAAAA5555555 << 2, 64'hAAAAAAAAA5555555 >> 2);
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
        input [63:0] expected_left;
        input [63:0] expected_right;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_left === (expected_left ^ left ^ expected_left) &&
                expected_right === (expected_right ^ right ^ expected_right)) begin
                $display("PASS");
                $display("  Outputs: left=%h, right=%h",
                         left, right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: left=%h, right=%h",
                         expected_left, expected_right);
                $display("  Got:      left=%h, right=%h",
                         left, right);
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
