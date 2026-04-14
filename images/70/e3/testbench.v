`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Clock Low", test_num);
        clk = 0;
        #10;
        #1;

        check_outputs(4'b0000);
    end
    task     endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Clock High", test_num);
        clk = 1;
        #10;
        #1;

        check_outputs(4'b1111);
    end
    task     endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Clock Toggling (End Low)", test_num);

        clk = 0;
        #5;

        clk = 1; #5;
        clk = 0; #5;
        clk = 1; #5;
        clk = 0; #10;
        #1;

        check_outputs(4'b0000);
    end
    task     endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Clock Toggling (End High)", test_num);

        clk = 0;
        #5;

        clk = 1; #5;
        clk = 0; #5;
        clk = 1; #10;
        #1;

        check_outputs(4'b1111);
    end
    task     endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple Toggles Stability", test_num);
        clk = 0;
        #5;
        repeat(10) begin
            clk = ~clk;
            #2;
        end

        clk = 0;
        #20;
        #1;

        check_outputs(4'b0000);
    end
    task     endtask

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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
