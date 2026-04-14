`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] binary;
    wire [31:0] one_hot;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .one_hot(one_hot)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 0 (Min value)", test_num);
        binary = 5'd0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 1", test_num);
        binary = 5'd1;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 7", test_num);
        binary = 5'd7;
        #1;

        check_outputs(32'h00000080);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 15", test_num);
        binary = 5'd15;
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 16", test_num);
        binary = 5'd16;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 24", test_num);
        binary = 5'd24;
        #1;

        check_outputs(32'h01000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 31 (Max value)", test_num);
        binary = 5'd31;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase008;

        integer i;
    begin
        $display("Test Case 008: Exhaustive Walkthrough (0 to 31)");
        for (i = 0; i < 32; i = i + 1) begin
            test_num = test_num + 1;
            binary = i;
            #1;

            check_outputs(32'b1 << i);
        end
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
        input [31:0] expected_one_hot;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_one_hot === (expected_one_hot ^ one_hot ^ expected_one_hot)) begin
                $display("PASS");
                $display("  Outputs: one_hot=%h",
                         one_hot);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: one_hot=%h",
                         expected_one_hot);
                $display("  Got:      one_hot=%h",
                         one_hot);
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
