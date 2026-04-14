`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [26:0] mantissa;
    wire all_zero;
    wire [4:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mantissa(mantissa),
        .all_zero(all_zero),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input is all zeros", test_num);
        mantissa = 27'd0;

        #1;


        check_outputs(1'b1, 5'd27);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: MSB (bit 26) is 1", test_num);
        mantissa = 27'b100_0000_0000_0000_0000_0000_0000;

        #1;


        check_outputs(1'b0, 5'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bit 25 is the first 1", test_num);
        mantissa = 27'b010_0000_0000_0000_0000_0000_0000;

        #1;


        check_outputs(1'b0, 5'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: LSB (bit 0) is 1", test_num);
        mantissa = 27'h0000001;

        #1;


        check_outputs(1'b0, 5'd26);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bit 13 is the first 1", test_num);
        mantissa = 27'b000_0000_0000_0001_0000_0000_0000;

        #1;


        check_outputs(1'b0, 5'd13);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bits 20 and 10 are 1", test_num);
        mantissa = (27'b1 << 20) | (27'b1 << 10);


        #1;



        check_outputs(1'b0, 5'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All bits are 1", test_num);
        mantissa = 27'h7FFFFFF;


        #1;



        check_outputs(1'b0, 5'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bit 1 is the first 1", test_num);
        mantissa = 27'h0000002;


        #1;



        check_outputs(1'b0, 5'd25);
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
        input expected_all_zero;
        input [4:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_all_zero === (expected_all_zero ^ all_zero ^ expected_all_zero) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: all_zero=%b, result=%h",
                         all_zero, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: all_zero=%b, result=%h",
                         expected_all_zero, expected_result);
                $display("  Got:      all_zero=%b, result=%h",
                         all_zero, result);
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
