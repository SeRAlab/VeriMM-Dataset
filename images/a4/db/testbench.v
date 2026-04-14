`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CI;
    reg CI_TOP;
    reg [7:0] DI;
    reg [7:0] S;
    wire [7:0] CO;
    wire [7:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CI(CI),
        .CI_TOP(CI_TOP),
        .DI(DI),
        .S(S),
        .CO(CO),
        .O(O)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero", test_num);
            CI = 0;
            CI_TOP = 0;
            DI = 8'h00;
            S = 8'h00;



            #1;




            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full carry propagation with CI=1", test_num);
            CI = 1;
            CI_TOP = 0;
            DI = 8'h00;
            S = 8'hFF;




            #1;





            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry generation from DI (S=0)", test_num);
            CI = 0;
            CI_TOP = 0;
            DI = 8'hAA;
            S = 8'h00;






            #1;







            check_outputs(8'hAA, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Propagate and Generate", test_num);
            CI = 0;
            CI_TOP = 0;
            DI = 8'hF0;
            S = 8'h0F;




            #1;





            check_outputs(8'hF0, 8'hEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs high except secondary carry", test_num);
            CI = 1;
            CI_TOP = 0;
            DI = 8'hFF;
            S = 8'hFF;


            #1;



            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing secondary carry-in (CI_TOP)", test_num);
            CI = 0;
            CI_TOP = 1;
            DI = 8'h00;
            S = 8'hFF;






            #1;







            check_outputs(CO, O);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sparse carry generation", test_num);
            CI = 0;
            CI_TOP = 0;
            DI = 8'h01;
            S = 8'hFE;



            #1;




            check_outputs(8'hFF, 8'h00);
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
        input [7:0] expected_CO;
        input [7:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: CO=%h, O=%h",
                         CO, O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%h, O=%h",
                         expected_CO, expected_O);
                $display("  Got:      CO=%h, O=%h",
                         CO, O);
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
