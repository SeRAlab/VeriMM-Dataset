`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_value;
    reg [4:0] shift_amount;
    wire [31:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_value(input_value),
        .shift_amount(shift_amount),
        .output_value(output_value)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Shift by 0", test_num);
        input_value = 32'hFFFFFFFF;
        shift_amount = 5'd0;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Shift MSB by 1", test_num);
        input_value = 32'h80000000;
        shift_amount = 5'd1;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Maximum shift (31)", test_num);
        input_value = 32'hFFFFFFFF;
        shift_amount = 5'd31;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Shift zero input", test_num);
        input_value = 32'h00000000;
        shift_amount = 5'd16;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Shift nibble alignment", test_num);
        input_value = 32'h12345678;
        shift_amount = 5'd4;
        #1;

        check_outputs(32'h01234567);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Shift alternating bits by 2", test_num);
        input_value = 32'hAAAAAAAA;
        shift_amount = 5'd2;
        #1;

        check_outputs(32'h2AAAAAAA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Shift pattern by 8 bits", test_num);
        input_value = 32'h55555555;
        shift_amount = 5'd8;
        #1;

        check_outputs(32'h00555555);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Shift repeating pattern by 20 bits", test_num);
        input_value = 32'hC0C0C0C0;
        shift_amount = 5'd20;
        #1;

        check_outputs(32'h00000C0C);
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
        input [31:0] expected_output_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: output_value=%h",
                         output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_value=%h",
                         expected_output_value);
                $display("  Got:      output_value=%h",
                         output_value);
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
