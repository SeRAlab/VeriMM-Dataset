`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] Data_A_i;
    reg [19:0] Data_B_i;
    wire CO;
    wire [3:0] DI;
    wire [2:0] O;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_A_i(Data_A_i),
        .Data_B_i(Data_B_i),
        .CO(CO),
        .DI(DI),
        .O(O),
        .S(S)
    );
    task perform_test;

        input [19:0] a;
        input [19:0] b;
        reg [20:0] full_sum;
        begin
            Data_A_i = a;
            Data_B_i = b;
            full_sum = a + b;
            #1;
            #1;

            check_outputs(
                full_sum[20],
                {full_sum[20], full_sum[19:17]},
                full_sum[2:0],
                full_sum[3:0]
            );
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Zero addition");
            perform_test(20'h00000, 20'h00000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Simple addition");
            perform_test(20'h00005, 20'h00002);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Carry into lower nibble");
            perform_test(20'h0000F, 20'h00001);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Max value carry-out");
            perform_test(20'hFFFFF, 20'h00001);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Upper sum bits");
            perform_test(20'hE0000, 20'h00000);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: CO and DI bits check");
            perform_test(20'hC0000, 20'hC0000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: All bits 1");
            perform_test(20'hFFFFF, 20'hFFFFF);
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
        input expected_CO;
        input [3:0] expected_DI;
        input [2:0] expected_O;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_DI === (expected_DI ^ DI ^ expected_DI) &&
                expected_O === (expected_O ^ O ^ expected_O) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, DI=%h, O=%h, S=%h",
                         CO, DI, O, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, DI=%h, O=%h, S=%h",
                         expected_CO, expected_DI, expected_O, expected_S);
                $display("  Got:      CO=%b, DI=%h, O=%h, S=%h",
                         CO, DI, O, S);
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
