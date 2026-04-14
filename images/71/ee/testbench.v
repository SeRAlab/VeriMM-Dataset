`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [6:0] Res;
    wire [6:0] ResS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Res(Res),
        .ResS(ResS)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying basic concatenation logic", test_num);






            #1;







            check_outputs(7'h59, 7'h59);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying unsigned interpretation (decimal 89)", test_num);

            #1;


            check_outputs(7'd89, 7'd89);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying signed interpretation (decimal -39)", test_num);





            #1;






            check_outputs(7'h59, 7'sb1011001);
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
        input [6:0] expected_Res;
        input [6:0] expected_ResS;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Res === (expected_Res ^ Res ^ expected_Res) &&
                expected_ResS === (expected_ResS ^ ResS ^ expected_ResS)) begin
                $display("PASS");
                $display("  Outputs: Res=%h, ResS=%h",
                         Res, ResS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Res=%h, ResS=%h",
                         expected_Res, expected_ResS);
                $display("  Got:      Res=%h, ResS=%h",
                         Res, ResS);
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
