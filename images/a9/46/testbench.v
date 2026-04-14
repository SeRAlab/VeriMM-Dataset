`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire [4:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase001: Lower Range Patterns");
            x = 4'b0000; #1;
 check_outputs(ref_model(4'b0000));
            x = 4'b0001; #1;
 check_outputs(ref_model(4'b0001));
            x = 4'b0010; #1;
 check_outputs(ref_model(4'b0010));
            x = 4'b0011; #1;
 check_outputs(ref_model(4'b0011));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase002: Mid-range Patterns");
            x = 4'b0100; #1;
 check_outputs(ref_model(4'b0100));
            x = 4'b0101; #1;
 check_outputs(ref_model(4'b0101));
            x = 4'b0110; #1;
 check_outputs(ref_model(4'b0110));
            x = 4'b0111; #1;
 check_outputs(ref_model(4'b0111));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase003: Upper Mid-range Patterns");
            x = 4'b1000; #1;
 check_outputs(ref_model(4'b1000));
            x = 4'b1001; #1;
 check_outputs(ref_model(4'b1001));
            x = 4'b1010; #1;
 check_outputs(ref_model(4'b1010));
            x = 4'b1011; #1;
 check_outputs(ref_model(4'b1011));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase004: Upper Range Patterns");
            x = 4'b1100; #1;
 check_outputs(ref_model(4'b1100));
            x = 4'b1101; #1;
 check_outputs(ref_model(4'b1101));
            x = 4'b1110; #1;
 check_outputs(ref_model(4'b1110));
            x = 4'b1111; #1;
 check_outputs(ref_model(4'b1111));
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
        input [4:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
