`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data;
    wire eqz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .eqz(eqz)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Testing Zero Input (data = 16'h0000)", test_num);
        data = 16'h0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Testing Minimum Non-Zero Input (data = 16'h0001)", test_num);
        data = 16'h0001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Testing Maximum Input (data = 16'hFFFF)", test_num);
        data = 16'hFFFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Testing Most Significant Bit Set (data = 16'h8000)", test_num);
        data = 16'h8000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Testing Alternating Bits (data = 16'hAAAA)", test_num);
        data = 16'hAAAA;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Testing Small Value (data = 16'h00FF)", test_num);
        data = 16'h00FF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Testing Middle Bit Set (data = 16'h0080)", test_num);
        data = 16'h0080;
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
        input expected_eqz;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eqz === (expected_eqz ^ eqz ^ expected_eqz)) begin
                $display("PASS");
                $display("  Outputs: eqz=%b",
                         eqz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eqz=%b",
                         expected_eqz);
                $display("  Got:      eqz=%b",
                         eqz);
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
