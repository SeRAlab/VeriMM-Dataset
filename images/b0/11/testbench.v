`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire lost;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .lost(lost),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All zeros", test_num);
        in = 4'b0000;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: LSB set, shift left", test_num);
        in = 4'b0001;
        #1;

        check_outputs(1'b0, 4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: MSB high (Data loss)", test_num);
        in = 4'b1000;
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0101", test_num);
        in = 4'b0101;
        #1;

        check_outputs(1'b0, 4'b1010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 1011 (Data loss)", test_num);
        in = 4'b1011;
        #1;

        check_outputs(1'b1, 4'b0110);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All ones", test_num);
        in = 4'b1111;
        #1;

        check_outputs(1'b1, 4'b1110);
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
        input expected_lost;
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lost === (expected_lost ^ lost ^ expected_lost) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: lost=%b, out=%h",
                         lost, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lost=%b, out=%h",
                         expected_lost, expected_out);
                $display("  Got:      lost=%b, out=%h",
                         lost, out);
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
