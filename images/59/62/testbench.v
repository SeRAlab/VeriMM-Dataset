`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    wire [2:0] code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .code(code)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs inactive", test_num);
        data = 4'b0000;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Lowest priority data[0] active", test_num);
        data = 4'b0001;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: data[1] active", test_num);
        data = 4'b0010;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: data[1] and data[0] active (data[1] should win)", test_num);
        data = 4'b0011;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: data[2] active", test_num);
        data = 4'b0100;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: data[2] and bits [1:0] active (data[2] should win)", test_num);
        data = 4'b0111;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: data[3] active", test_num);
        data = 4'b1000;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: data[3] and data[2] active (data[3] should win)", test_num);
        data = 4'b1100;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: data[3] and data[0] active (data[3] should win)", test_num);
        data = 4'b1001;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: All inputs active (Highest priority data[3] should win)", test_num);
        data = 4'b1111;
        #1;

        check_outputs(3'd3);
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
        input [2:0] expected_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_code === (expected_code ^ code ^ expected_code)) begin
                $display("PASS");
                $display("  Outputs: code=%h",
                         code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code=%h",
                         expected_code);
                $display("  Got:      code=%h",
                         code);
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
