`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] d;
    wire [63:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .q(q)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input d = 0", test_num);
        d = 6'd0;
        #1;

        check_outputs(64'h0000000000000001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input d = 1", test_num);
        d = 6'd1;
        #1;

        check_outputs(64'h0000000000000002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input d = 5", test_num);
        d = 6'd5;
        #1;

        check_outputs(64'h0000000000000020);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input d = 10", test_num);
        d = 6'd10;
        #1;

        check_outputs(64'h0000000000000400);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Input d = 15", test_num);
        d = 6'd15;
        #1;

        check_outputs(64'h0000000000008000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Input d = 31", test_num);
        d = 6'd31;
        #1;

        check_outputs(64'h0000000080000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Input d = 32", test_num);
        d = 6'd32;
        #1;

        check_outputs(64'h0000000100000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Input d = 47", test_num);
        d = 6'd47;
        #1;

        check_outputs(64'h0000800000000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Input d = 60", test_num);
        d = 6'd60;
        #1;

        check_outputs(64'h1000000000000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Input d = 63 (Edge Case)", test_num);
        d = 6'd63;
        #1;

        check_outputs(64'h8000000000000000);
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
        input [63:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
