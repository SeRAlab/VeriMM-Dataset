`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    reg [3:0] y;
    wire [3:0] out_and;
    wire [3:0] out_or;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .out_and(out_and),
        .out_or(out_or)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        x = 4'b0000;
        y = 4'b0000;
        #1;

        check_outputs(4'b0000, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        x = 4'b1111;
        y = 4'b1111;
        #1;

        check_outputs(4'b1111, 4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits No Overlap", test_num);
        x = 4'b1010;
        y = 4'b0101;
        #1;

        check_outputs(4'b0000, 4'b1111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits Full Overlap", test_num);
        x = 4'b1010;
        y = 4'b1010;
        #1;

        check_outputs(4'b1010, 4'b1010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mixed Patterns 1", test_num);
        x = 4'b1100;
        y = 4'b1010;
        #1;

        check_outputs(4'b1000, 4'b1110);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mixed Patterns 2", test_num);
        x = 4'b0110;
        y = 4'b0011;
        #1;

        check_outputs(4'b0010, 4'b0111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: MSB and LSB Bits", test_num);
        x = 4'b1001;
        y = 4'b1100;
        #1;

        check_outputs(4'b1000, 4'b1101);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: X All Ones Y All Zeros", test_num);
        x = 4'b1111;
        y = 4'b0000;
        #1;

        check_outputs(4'b0000, 4'b1111);
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
        input [3:0] expected_out_and;
        input [3:0] expected_out_or;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_or=%h",
                         out_and, out_or);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_or=%h",
                         expected_out_and, expected_out_or);
                $display("  Got:      out_and=%h, out_or=%h",
                         out_and, out_or);
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
