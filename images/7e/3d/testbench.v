`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] h;
    reg [7:0] i;
    wire [7:0] j;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .h(h),
        .i(i),
        .j(j)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic subtraction (Positive result)", test_num);
        h = 8'd50;
        i = 8'd20;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtracting zero", test_num);
        h = 8'd100;
        i = 8'd0;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtracting from zero (Underflow/Wrap-around)", test_num);
        h = 8'd0;
        i = 8'd1;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Result is zero", test_num);
        h = 8'd255;
        i = 8'd255;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large underflow", test_num);
        h = 8'd10;
        i = 8'd20;
        #1;

        check_outputs(8'd246);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtracting max from zero", test_num);
        h = 8'd0;
        i = 8'd255;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary values", test_num);
        h = 8'd255;
        i = 8'd1;
        #1;

        check_outputs(8'd254);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-range subtraction", test_num);
        h = 8'd128;
        i = 8'd64;
        #1;

        check_outputs(8'd64);
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
        input [7:0] expected_j;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_j === (expected_j ^ j ^ expected_j)) begin
                $display("PASS");
                $display("  Outputs: j=%h",
                         j);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: j=%h",
                         expected_j);
                $display("  Got:      j=%h",
                         j);
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
