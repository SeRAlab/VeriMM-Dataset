`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All zeros", test_num);
        a = 8'b00000000;
        #1;

        check_outputs(8'b11111111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: All ones", test_num);
        a = 8'b11111111;
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Alternating bits AA", test_num);
        a = 8'hAA;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Alternating bits 55", test_num);
        a = 8'h55;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Walking bit (LSB)", test_num);
        a = 8'h01;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Walking bit (MSB)", test_num);
        a = 8'h80;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Middle bits", test_num);
        a = 8'h3C;
        #1;

        check_outputs(8'hC3);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Complex pattern", test_num);
        a = 8'hA5;
        #1;

        check_outputs(8'h5A);
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
