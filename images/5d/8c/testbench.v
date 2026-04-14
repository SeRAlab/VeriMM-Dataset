`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] signal_a;
    reg [7:0] signal_b;
    reg sleep_mode;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .signal_a(signal_a),
        .signal_b(signal_b),
        .sleep_mode(sleep_mode),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sleep mode active", test_num);
            signal_a = 8'd50;
            signal_b = 8'd25;
            sleep_mode = 1'b1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal operation (5 + 10<<1)", test_num);
            signal_a = 8'd5;
            signal_b = 8'd10;
            sleep_mode = 1'b0;

            #1;


            check_outputs(8'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs are zero", test_num);
            signal_a = 8'd0;
            signal_b = 8'd0;
            sleep_mode = 1'b0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum 8-bit value check (1 + 127<<1)", test_num);
            signal_a = 8'd1;
            signal_b = 8'd127;
            sleep_mode = 1'b0;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow check (10 + 130<<1)", test_num);
            signal_a = 8'd10;
            signal_b = 8'd130;
            sleep_mode = 1'b0;


            #1;



            check_outputs(8'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Re-entering sleep mode", test_num);
            signal_a = 8'hFF;
            signal_b = 8'hFF;
            sleep_mode = 1'b1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: signal_b is zero", test_num);
            signal_a = 8'd42;
            signal_b = 8'd0;
            sleep_mode = 1'b0;
            #1;

            check_outputs(8'd42);
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
