`timescale 1ns/1ps

module and_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg enable;
    reg reset;
    wire [7:0] and_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and_module dut (
        .a(a),
        .b(b),
        .enable(enable),
        .reset(reset),
        .and_result(and_result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset Priority", test_num);
        reset = 1;
        enable = 1;
        a = 8'hFF;
        b = 8'hFF;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable High - Full AND (FF & FF)", test_num);
        reset = 1; #5; reset = 0;
        enable = 1;
        a = 8'hFF;
        b = 8'hFF;
        #10;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable High - Alternating Bits (AA & 55)", test_num);
        reset = 1; #5; reset = 0;
        enable = 1;
        a = 8'hAA;
        b = 8'h55;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable High - Nibble Masking (F0 & CC)", test_num);
        reset = 1; #5; reset = 0;
        enable = 1;
        a = 8'hF0;
        b = 8'hCC;
        #10;
        #1;

        check_outputs(8'hC0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable High - Zero Input (FF & 00)", test_num);
        reset = 1; #5; reset = 0;
        enable = 1;
        a = 8'hFF;
        b = 8'h00;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify Reset Clears Active Result", test_num);

        reset = 0; enable = 1; a = 8'hFF; b = 8'hFF;
        #10;

        reset = 1;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and_module Testbench");
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
        input [7:0] expected_and_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_result === (expected_and_result ^ and_result ^ expected_and_result)) begin
                $display("PASS");
                $display("  Outputs: and_result=%h",
                         and_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_result=%h",
                         expected_and_result);
                $display("  Got:      and_result=%h",
                         and_result);
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
