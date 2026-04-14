`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] const_val;
    reg [3:0] in_val;
    wire [3:0] out_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .const_val(const_val),
        .in_val(in_val),
        .out_val(out_val)
    );
    task testcase001;

    begin
        test_num = 1;
        in_val = 4'd0;
        const_val = 4'd0;
        $display("Test %0d: in_val=0, const_val=0 (Sum=0, Expected=0)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in_val = 4'd2;
        const_val = 4'd3;
        $display("Test %0d: in_val=2, const_val=3 (Sum=5, Expected=5)", test_num);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in_val = 4'd4;
        const_val = 4'd3;
        $display("Test %0d: in_val=4, const_val=3 (Sum=7, Expected=7)", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in_val = 4'd4;
        const_val = 4'd4;
        $display("Test %0d: in_val=4, const_val=4 (Sum=8, Expected=7)", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in_val = 4'd15;
        const_val = 4'd15;
        $display("Test %0d: in_val=15, const_val=15 (Sum=30, Expected=7)", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in_val = 4'd10;
        const_val = 4'd0;
        $display("Test %0d: in_val=10, const_val=0 (Sum=10, Expected=7)", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in_val = 4'd1;
        const_val = 4'd6;
        $display("Test %0d: in_val=1, const_val=6 (Sum=7, Expected=7)", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in_val = 4'd0;
        const_val = 4'd15;
        $display("Test %0d: in_val=0, const_val=15 (Sum=15, Expected=7)", test_num);
        #1;

        check_outputs(4'd7);
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
        input [3:0] expected_out_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_val === (expected_out_val ^ out_val ^ expected_out_val)) begin
                $display("PASS");
                $display("  Outputs: out_val=%h",
                         out_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_val=%h",
                         expected_out_val);
                $display("  Got:      out_val=%h",
                         out_val);
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
