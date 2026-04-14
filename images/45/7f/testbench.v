`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg b;
    reg eq;
    reg ovf;
    wire [2:0] leds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .eq(eq),
        .ovf(ovf),
        .leds(leds)
    );
    task testcase001;

        begin
            test_num = 1;
            ovf = 0; b = 0; eq = 0;
            $display("\nTest Case %0d: All inputs low", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ovf = 1; b = 0; eq = 0;
            $display("\nTest Case %0d: ovf high", test_num);
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ovf = 0; b = 1; eq = 0;
            $display("\nTest Case %0d: b high", test_num);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ovf = 0; b = 0; eq = 1;
            $display("\nTest Case %0d: eq high", test_num);
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ovf = 1; b = 1; eq = 0;
            $display("\nTest Case %0d: ovf and b high", test_num);
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ovf = 1; b = 0; eq = 1;
            $display("\nTest Case %0d: ovf and eq high", test_num);
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            ovf = 0; b = 1; eq = 1;
            $display("\nTest Case %0d: b and eq high", test_num);
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            ovf = 1; b = 1; eq = 1;
            $display("\nTest Case %0d: All inputs high", test_num);
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
        input [2:0] expected_leds;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_leds === (expected_leds ^ leds ^ expected_leds)) begin
                $display("PASS");
                $display("  Outputs: leds=%h",
                         leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: leds=%h",
                         expected_leds);
                $display("  Got:      leds=%h",
                         leds);
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
