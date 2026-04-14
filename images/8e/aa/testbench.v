`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire greater_or_equal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .greater_or_equal(greater_or_equal)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A=0, B=0 (Equality)", test_num);
        A = 4'b0000; B = 4'b0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A=15, B=15 (Equality)", test_num);
        A = 4'b1111; B = 4'b1111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A=8, B=7 (MSB comparison A > B)", test_num);
        A = 4'b1000; B = 4'b0111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A=7, B=8 (MSB comparison A < B)", test_num);
        A = 4'b0111; B = 4'b1000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A=12, B=8 (Lower bit comparison A > B)", test_num);
        A = 4'b1100; B = 4'b1000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A=8, B=12 (Lower bit comparison A < B)", test_num);
        A = 4'b1000; B = 4'b1100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A=1, B=0 (LSB comparison A > B)", test_num);
        A = 4'b0001; B = 4'b0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A=0, B=1 (LSB comparison A < B)", test_num);
        A = 4'b0000; B = 4'b0001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A=15, B=0 (Extreme range)", test_num);
        A = 4'b1111; B = 4'b0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A=0, B=15 (Extreme range)", test_num);
        A = 4'b0000; B = 4'b1111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A=10, B=9 (Arbitrary comparison)", test_num);
        A = 4'b1010; B = 4'b1001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A=5, B=6 (Arbitrary comparison)", test_num);
        A = 4'b0101; B = 4'b0110;
        #1;

        check_outputs(1'b0);
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
        testcase012();
        
        
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
        input expected_greater_or_equal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_greater_or_equal === (expected_greater_or_equal ^ greater_or_equal ^ expected_greater_or_equal)) begin
                $display("PASS");
                $display("  Outputs: greater_or_equal=%b",
                         greater_or_equal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: greater_or_equal=%b",
                         expected_greater_or_equal);
                $display("  Got:      greater_or_equal=%b",
                         greater_or_equal);
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
