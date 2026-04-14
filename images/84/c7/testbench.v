`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg BC;
    reg JB;
    reg N;
    reg PL;
    reg Z;
    wire [1:0] K;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BC(BC),
        .JB(JB),
        .N(N),
        .PL(PL),
        .Z(Z),
        .K(K)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs low", test_num);
            PL = 0; JB = 0; BC = 0; Z = 0; N = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: K[1] Condition 1 (PL=1, JB=0, BC=0, Z=1)", test_num);
            PL = 1; JB = 0; BC = 0; Z = 1; N = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: K[1] Condition 2 (PL=1, JB=0, BC=1, N=1)", test_num);
            PL = 1; JB = 0; BC = 1; Z = 0; N = 1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: K[0] Condition (PL=1, JB=1)", test_num);
            PL = 1; JB = 1; BC = 0; Z = 0; N = 0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: PL=1 but no branch conditions met", test_num);
            PL = 1; JB = 0; BC = 0; Z = 0; N = 1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: PL=0 with flags active", test_num);
            PL = 0; JB = 1; BC = 1; Z = 1; N = 1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: K[1] Condition 1 with N high (N should be ignored)", test_num);
            PL = 1; JB = 0; BC = 0; Z = 1; N = 1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: K[1] Condition 2 with Z high (Z should be ignored)", test_num);
            PL = 1; JB = 0; BC = 1; Z = 1; N = 1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs high", test_num);
            PL = 1; JB = 1; BC = 1; Z = 1; N = 1;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: JB high, PL low", test_num);
            PL = 0; JB = 1; BC = 0; Z = 0; N = 0;
            #1;

            check_outputs(2'b00);
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
        testcase010();
        
        
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
        input [1:0] expected_K;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_K === (expected_K ^ K ^ expected_K)) begin
                $display("PASS");
                $display("  Outputs: K=%h",
                         K);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: K=%h",
                         expected_K);
                $display("  Got:      K=%h",
                         K);
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
