`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [3:0] bcd1;
    wire [3:0] bcd2;
    wire [3:0] bcd3;
    wire [3:0] bcd4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .bcd1(bcd1),
        .bcd2(bcd2),
        .bcd3(bcd3),
        .bcd4(bcd4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input bin = 0", test_num);
            bin = 4'd0;
            #1;

            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input bin = 5", test_num);
            bin = 4'd5;
            #1;

            check_outputs(4'd5, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input bin = 9", test_num);
            bin = 4'd9;
            #1;

            check_outputs(4'd9, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input bin = 10 (Boundary Case)", test_num);
            bin = 4'd10;
            #1;

            check_outputs(4'd0, 4'd1, 4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input bin = 12", test_num);
            bin = 4'd12;
            #1;

            check_outputs(4'd2, 4'd1, 4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input bin = 15 (Maximum Value)", test_num);
            bin = 4'd15;
            #1;

            check_outputs(4'd5, 4'd1, 4'd0, 4'd0);
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
        input [3:0] expected_bcd1;
        input [3:0] expected_bcd2;
        input [3:0] expected_bcd3;
        input [3:0] expected_bcd4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd1 === (expected_bcd1 ^ bcd1 ^ expected_bcd1) &&
                expected_bcd2 === (expected_bcd2 ^ bcd2 ^ expected_bcd2) &&
                expected_bcd3 === (expected_bcd3 ^ bcd3 ^ expected_bcd3) &&
                expected_bcd4 === (expected_bcd4 ^ bcd4 ^ expected_bcd4)) begin
                $display("PASS");
                $display("  Outputs: bcd1=%h, bcd2=%h, bcd3=%h, bcd4=%h",
                         bcd1, bcd2, bcd3, bcd4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd1=%h, bcd2=%h, bcd3=%h, bcd4=%h",
                         expected_bcd1, expected_bcd2, expected_bcd3, expected_bcd4);
                $display("  Got:      bcd1=%h, bcd2=%h, bcd3=%h, bcd4=%h",
                         bcd1, bcd2, bcd3, bcd4);
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
