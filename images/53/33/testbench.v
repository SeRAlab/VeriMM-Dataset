`timescale 1ns/1ps

module not_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg enable;
    reg reset;
    wire [7:0] not_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    not_module dut (
        .a(a),
        .enable(enable),
        .reset(reset),
        .not_result(not_result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Priority Test (Reset=1, Enable=1, a=0xFF)", test_num);
            reset = 1;
            enable = 1;
            a = 8'hFF;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Normal Operation (Reset=0, Enable=1, a=0x00)", test_num);
            reset = 1; #10;
            reset = 0;
            enable = 1;
            a = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Normal Operation (Reset=0, Enable=1, a=0xFF)", test_num);
            reset = 1; #10;
            reset = 0;
            enable = 1;
            a = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Bitwise Pattern (Reset=0, Enable=1, a=0xAA)", test_num);
            reset = 1; #10;
            reset = 0;
            enable = 1;
            a = 8'hAA;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Bitwise Pattern (Reset=0, Enable=1, a=0x55)", test_num);
            reset = 1; #10;
            reset = 0;
            enable = 1;
            a = 8'h55;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Complex Pattern (Reset=0, Enable=1, a=0x12)", test_num);
            reset = 1; #10;
            reset = 0;
            enable = 1;
            a = 8'h12;
            #1;

            check_outputs(8'hED);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Reset mid-operation", test_num);
            reset = 0;
            enable = 1;
            a = 8'hF0;
            #5;
            reset = 1;
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
        $display("not_module Testbench");
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
        input [7:0] expected_not_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_not_result === (expected_not_result ^ not_result ^ expected_not_result)) begin
                $display("PASS");
                $display("  Outputs: not_result=%h",
                         not_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: not_result=%h",
                         expected_not_result);
                $display("  Got:      not_result=%h",
                         not_result);
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
