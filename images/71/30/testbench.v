`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] ki;
    wire [127:0] ko;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ki(ki),
        .ko(ko)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros", test_num);
            ki = 128'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All Ones", test_num);
            ki = {128{1'b1}};
            #1;

            check_outputs({128{1'b1}});
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Sequential Byte Pattern", test_num);
            ki = 128'h000102030405060708090A0B0C0D0E0F;

            #1;


            check_outputs(128'h0004080C0105090D02060A0E03070B0F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Alternating Word Pattern", test_num);

            ki = 128'hAA55AA55BB66BB66CC77CC77DD88DD88;

            #1;


            check_outputs(128'hAABBCCDD55667788AABBCCDD55667788);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Nibble Gradient Pattern", test_num);
            ki = 128'hF0E1D2C3B4A5968778695A4B3C2D1E0F;





            #1;






            check_outputs(128'hF0B4783CE1A5692DD2965A1EC3874B0F);
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
        input [127:0] expected_ko;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ko === (expected_ko ^ ko ^ expected_ko)) begin
                $display("PASS");
                $display("  Outputs: ko=%h",
                         ko);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ko=%h",
                         expected_ko);
                $display("  Got:      ko=%h",
                         ko);
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
