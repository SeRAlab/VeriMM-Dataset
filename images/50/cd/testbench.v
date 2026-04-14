`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_data;
    reg reset;
    wire [2:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_data(in_data),
        .reset(reset),
        .out_data(out_data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Assert Reset", test_num);
        reset = 1'b1;
        in_data = 4'd5;
        #10;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Deassert Reset, Input 0 (0+2=2)", test_num);
        reset = 1'b0;
        in_data = 4'd0;
        #10;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Deassert Reset, Input 3 (3+2=5)", test_num);
        reset = 1'b0;
        in_data = 4'd3;
        #10;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Deassert Reset, Input 5 (5+2=7)", test_num);
        reset = 1'b0;
        in_data = 4'd5;
        #10;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Deassert Reset, Input 6 (6+2=8, truncate to 0)", test_num);
        reset = 1'b0;
        in_data = 4'd6;
        #10;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Deassert Reset, Input 15 (15+2=17, truncate to 1)", test_num);
        reset = 1'b0;
        in_data = 4'd15;
        #10;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Re-assert Reset with high input", test_num);
        reset = 1'b1;
        in_data = 4'd15;
        #10;
        #1;

        check_outputs(3'd0);
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
        input [2:0] expected_out_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
