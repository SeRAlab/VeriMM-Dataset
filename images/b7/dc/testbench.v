`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] x;
    reg [1:0] y;
    wire [1:0] cout;
    wire s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .cout(cout),
        .s(s)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        x = 2'b00; y = 2'b00;
        $display("Test case %0d: x=%d, y=%d (Expected s=0, cout=0)", test_num, x, y);
        #1;

        check_outputs(2'b00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        x = 2'b01; y = 2'b00;
        $display("Test case %0d: x=%d, y=%d (Expected s=1, cout=0)", test_num, x, y);
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        x = 2'b01; y = 2'b01;
        $display("Test case %0d: x=%d, y=%d (Expected s=0, cout=1)", test_num, x, y);
        #1;

        check_outputs(2'b01, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        x = 2'b10; y = 2'b01;
        $display("Test case %0d: x=%d, y=%d (Expected s=1, cout=1)", test_num, x, y);
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        x = 2'b10; y = 2'b10;
        $display("Test case %0d: x=%d, y=%d (Expected s=0, cout=2)", test_num, x, y);
        #1;

        check_outputs(2'b10, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        x = 2'b11; y = 2'b01;
        $display("Test case %0d: x=%d, y=%d (Expected s=0, cout=2)", test_num, x, y);
        #1;

        check_outputs(2'b10, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        x = 2'b11; y = 2'b10;
        $display("Test case %0d: x=%d, y=%d (Expected s=1, cout=2)", test_num, x, y);
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        x = 2'b11; y = 2'b11;
        $display("Test case %0d: x=%d, y=%d (Expected s=0, cout=3)", test_num, x, y);
        #1;

        check_outputs(2'b11, 1'b0);
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
        input [1:0] expected_cout;
        input expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, s=%b",
                         cout, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, s=%b",
                         expected_cout, expected_s);
                $display("  Got:      cout=%h, s=%b",
                         cout, s);
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
