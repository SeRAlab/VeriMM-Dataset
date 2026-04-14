`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] mih_o;
    reg [15:0] wager_o;
    wire [15:0] mih_b;
    wire [15:0] wager_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mih_o(mih_o),
        .wager_o(wager_o),
        .mih_b(mih_b),
        .wager_b(wager_b)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            mih_o = 16'd0;
            wager_o = 16'd0;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple multi-digit conversion", test_num);
            mih_o = 16'd1234;
            wager_o = 16'd5678;
            #1;

            check_outputs(16'h1234, 16'h5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum 4-digit BCD values", test_num);
            mih_o = 16'd9999;
            wager_o = 16'd9999;
            #1;

            check_outputs(16'h9999, 16'h9999);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single and double digit inputs", test_num);
            mih_o = 16'd7;
            wager_o = 16'd42;
            #1;

            check_outputs(16'h0007, 16'h0042);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of 10 boundaries", test_num);
            mih_o = 16'd1000;
            wager_o = 16'd100;
            #1;

            check_outputs(16'h1000, 16'h0100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Specific numeric patterns", test_num);
            mih_o = 16'd2048;
            wager_o = 16'd8192;
            #1;

            check_outputs(16'h2048, 16'h8192);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Internal zeros", test_num);
            mih_o = 16'd1001;
            wager_o = 16'd5050;
            #1;

            check_outputs(16'h1001, 16'h5050);
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
        input [15:0] expected_mih_b;
        input [15:0] expected_wager_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mih_b === (expected_mih_b ^ mih_b ^ expected_mih_b) &&
                expected_wager_b === (expected_wager_b ^ wager_b ^ expected_wager_b)) begin
                $display("PASS");
                $display("  Outputs: mih_b=%h, wager_b=%h",
                         mih_b, wager_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mih_b=%h, wager_b=%h",
                         expected_mih_b, expected_wager_b);
                $display("  Got:      mih_b=%h, wager_b=%h",
                         mih_b, wager_b);
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
