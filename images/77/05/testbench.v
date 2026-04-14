`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CI;
    reg CYINIT;
    reg [3:0] DI;
    reg [3:0] S;
    wire [3:0] CO;
    wire [3:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CI(CI),
        .CYINIT(CYINIT),
        .DI(DI),
        .S(S),
        .CO(CO),
        .O(O)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            CI = 0; CYINIT = 0; DI = 4'h0; S = 4'h0;
            #10;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Propagation via CI", test_num);
            CI = 1; CYINIT = 0; DI = 4'h0; S = 4'hF;
            #10;

            #1;


            check_outputs(4'hF, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Propagation via CYINIT", test_num);
            CI = 0; CYINIT = 1; DI = 4'h0; S = 4'hF;
            #10;

            #1;


            check_outputs(4'hF, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Generation (No Propagation)", test_num);
            CI = 0; CYINIT = 0; DI = 4'hF; S = 4'h0;
            #10;


            #1;



            check_outputs(4'hF, 4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checkerboard Pattern A", test_num);
            CI = 1; CYINIT = 0; DI = 4'h5; S = 4'hA;
            #10;



            #1;




            check_outputs(4'hF, 4'h5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checkerboard Pattern B", test_num);
            CI = 0; CYINIT = 0; DI = 4'hA; S = 4'h5;
            #10;




            #1;





            check_outputs(4'hE, 4'h9);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry Chain Break", test_num);
            CI = 1; CYINIT = 0; DI = 4'h0; S = 4'hE;
            #10;



            #1;




            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Propagate Only (CI=0)", test_num);
            CI = 0; CYINIT = 0; DI = 4'h0; S = 4'hF;
            #10;

            #1;


            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Carry Logic", test_num);
            CI = 1; CYINIT = 0; DI = 4'h6; S = 4'h9;
            #10;





            #1;






            check_outputs(4'hF, 4'h6);
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
        testcase009();
        
        
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
        input [3:0] expected_CO;
        input [3:0] expected_O;
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
