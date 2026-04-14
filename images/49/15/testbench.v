`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ctrl;
    reg [6:0] wiper_pos;
    wire [6:0] resistance;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .wiper_pos(wiper_pos),
        .resistance(resistance)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum resistance (Zero Position)", test_num);
            ctrl = 4'b0000;
            wiper_pos = 7'b0000000;

            #1;


            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum wiper position", test_num);
            ctrl = 4'b0001;
            wiper_pos = 7'b1111111;

            #1;


            check_outputs(7'd127);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-scale wiper position", test_num);
            ctrl = 4'b0001;
            wiper_pos = 7'd64;
            #1;

            check_outputs(7'd64);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum control signal with mid wiper", test_num);
            ctrl = 4'b0000;
            wiper_pos = 7'd32;

            #1;


            check_outputs(7'd32);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary test - Max wiper, Max control", test_num);
            ctrl = 4'b1111;
            wiper_pos = 7'd127;

            #1;


            check_outputs(7'd127);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Incremental step test", test_num);
            ctrl = 4'b0010;
            wiper_pos = 7'd1;
            #1;

            check_outputs(7'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Small wiper position change", test_num);
            ctrl = 4'b1010;
            wiper_pos = 7'd10;
            #1;

            check_outputs(7'd10);
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
        input [6:0] expected_resistance;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_resistance === (expected_resistance ^ resistance ^ expected_resistance)) begin
                $display("PASS");
                $display("  Outputs: resistance=%h",
                         resistance);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resistance=%h",
                         expected_resistance);
                $display("  Got:      resistance=%h",
                         resistance);
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
