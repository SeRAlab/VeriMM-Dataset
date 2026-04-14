`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg I0;
    reg I1;
    reg I2;
    reg I3;
    reg I4;
    reg I5;
    wire O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .I4(I4),
        .I5(I5),
        .O(O)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs Zero (Index 0)", test_num);
        {I5, I4, I3, I2, I1, I0} = 6'b000000;
        #1;

        check_outputs(REF_INIT[0]);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input I0 High (Index 1)", test_num);
        {I5, I4, I3, I2, I1, I0} = 6'b000001;
        #1;

        check_outputs(REF_INIT[1]);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input I1 High (Index 2)", test_num);
        {I5, I4, I3, I2, I1, I0} = 6'b000010;
        #1;

        check_outputs(REF_INIT[2]);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input I2 High (Index 4)", test_num);
        {I5, I4, I3, I2, I1, I0} = 6'b000100;
        #1;

        check_outputs(REF_INIT[4]);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input I3 High (Index 8)", test_num);
        {I5, I4, I3, I2, I1, I0} = 6'b001000;
        #1;

        check_outputs(REF_INIT[8]);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input I4 High (Index 16)", test_num);
        {I5, I4, I3, I2, I1, I0} = 6'b010000;
        #1;

        check_outputs(REF_INIT[16]);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input I5 High (Index 32)", test_num);
        {I5, I4, I3, I2, I1, I0} = 6'b100000;
        #1;

        check_outputs(REF_INIT[32]);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs High (Index 63)", test_num);
        {I5, I4, I3, I2, I1, I0} = 6'b111111;
        #1;

        check_outputs(REF_INIT[63]);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern 101010 (Index 42)", test_num);
        {I5, I4, I3, I2, I1, I0} = 6'b101010;
        #1;

        check_outputs(REF_INIT[42]);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern 010101 (Index 21)", test_num);
        {I5, I4, I3, I2, I1, I0} = 6'b010101;
        #1;

        check_outputs(REF_INIT[21]);
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
        input expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%b",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%b",
                         expected_O);
                $display("  Got:      O=%b",
                         O);
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
