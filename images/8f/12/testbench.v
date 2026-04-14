`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_value;
    wire [2:0] out_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_value(in_value),
        .out_value(out_value)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: in_value = 0 (Minimum legal)", test_num);
        in_value = 4'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: in_value = 3 (Legal, no MSB change needed)", test_num);
        in_value = 4'd3;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: in_value = 4 (Legal, MSB forced to 0)", test_num);
        in_value = 4'd4;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: in_value = 5 (Legal, MSB forced to 0)", test_num);
        in_value = 4'd5;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: in_value = 7 (Boundary legal)", test_num);
        in_value = 4'd7;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: in_value = 8 (Boundary overflow)", test_num);
        in_value = 4'd8;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: in_value = 10 (Overflow)", test_num);
        in_value = 4'd10;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: in_value = 15 (Maximum input)", test_num);
        in_value = 4'd15;
        #1;

        check_outputs(3'b111);
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
        input [2:0] expected_out_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_value === (expected_out_value ^ out_value ^ expected_out_value)) begin
                $display("PASS");
                $display("  Outputs: out_value=%h",
                         out_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_value=%h",
                         expected_out_value);
                $display("  Got:      out_value=%h",
                         out_value);
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
