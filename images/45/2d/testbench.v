`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .Zero(Zero)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Equality - Both Zero", test_num);
        in1 = 32'h00000000;
        in2 = 32'h00000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Equality - Both Max Value", test_num);
        in1 = 32'hFFFFFFFF;
        in2 = 32'hFFFFFFFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Equality - Alternating bits", test_num);
        in1 = 32'hAAAAAAAA;
        in2 = 32'hAAAAAAAA;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Inequality - LSB differs", test_num);
        in1 = 32'h00000000;
        in2 = 32'h00000001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Inequality - MSB differs", test_num);
        in1 = 32'h80000000;
        in2 = 32'h00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Inequality - Middle bit differs", test_num);
        in1 = 32'h00001000;
        in2 = 32'h00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Inequality - Completely different values", test_num);
        in1 = 32'h12345678;
        in2 = 32'h87654321;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Inequality - 32nd bit vs 31st bit", test_num);
        in1 = 32'h40000000;
        in2 = 32'h20000000;
        #1;

        check_outputs(1'b0);
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
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Zero=%b",
                         Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Zero=%b",
                         expected_Zero);
                $display("  Got:      Zero=%b",
                         Zero);
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
