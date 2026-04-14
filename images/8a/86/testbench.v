`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ABCD;
    wire [1:0] XY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ABCD(ABCD),
        .XY(XY)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs inactive (ABCD=0000)", test_num);
        ABCD = 4'b0000;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Only input D active (ABCD=0001)", test_num);
        ABCD = 4'b0001;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Only input C active (ABCD=0010)", test_num);
        ABCD = 4'b0010;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Only input B active (ABCD=0100)", test_num);
        ABCD = 4'b0100;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Only input A active (ABCD=1000)", test_num);
        ABCD = 4'b1000;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A and D active (ABCD=1001)", test_num);
        ABCD = 4'b1001;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: B and C active (ABCD=0110)", test_num);
        ABCD = 4'b0110;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: C and D active (ABCD=0011)", test_num);
        ABCD = 4'b0011;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A, B, and C active (ABCD=1110)", test_num);
        ABCD = 4'b1110;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs active (ABCD=1111)", test_num);
        ABCD = 4'b1111;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: B and D active (ABCD=0101)", test_num);
        ABCD = 4'b0101;
        #1;

        check_outputs(2'b10);
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
        input [1:0] expected_XY;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_XY === (expected_XY ^ XY ^ expected_XY)) begin
                $display("PASS");
                $display("  Outputs: XY=%h",
                         XY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: XY=%h",
                         expected_XY);
                $display("  Got:      XY=%h",
                         XY);
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
