`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CE0;
    reg CE1;
    reg I0;
    reg I1;
    reg IGNORE0;
    reg IGNORE1;
    reg S0;
    reg S1;
    wire O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CE0(CE0),
        .CE1(CE1),
        .I0(I0),
        .I1(I1),
        .IGNORE0(IGNORE0),
        .IGNORE1(IGNORE1),
        .S0(S0),
        .S1(S1),
        .O(O)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Select I0 with CE0 active", test_num);
        I0 = 1; I1 = 0;
        S0 = 1; S1 = 0;
        CE0 = 1; CE1 = 0;
        IGNORE0 = 0; IGNORE1 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Select I0 with CE0 active, but I0 is 0", test_num);
        I0 = 0; I1 = 1;
        S0 = 1; S1 = 0;
        CE0 = 1; CE1 = 0;
        IGNORE0 = 0; IGNORE1 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Select I1 with CE1 active", test_num);
        I0 = 0; I1 = 1;
        S0 = 0; S1 = 1;
        CE0 = 0; CE1 = 1;
        IGNORE0 = 0; IGNORE1 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Select I1 with CE1 active, but I1 is 0", test_num);
        I0 = 1; I1 = 0;
        S0 = 0; S1 = 1;
        CE0 = 0; CE1 = 1;
        IGNORE0 = 0; IGNORE1 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Select I0 with CE0 inactive", test_num);
        I0 = 1; I1 = 1;
        S0 = 1; S1 = 0;
        CE0 = 0; CE1 = 0;
        IGNORE0 = 0; IGNORE1 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Select I0 with IGNORE0 active (overrides CE0)", test_num);
        I0 = 1; I1 = 0;
        S0 = 1; S1 = 0;
        CE0 = 0; CE1 = 0;
        IGNORE0 = 1; IGNORE1 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Select I1 with IGNORE1 active (overrides CE1)", test_num);
        I0 = 0; I1 = 1;
        S0 = 0; S1 = 1;
        CE0 = 0; CE1 = 0;
        IGNORE0 = 0; IGNORE1 = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: No select active (S0=0, S1=0)", test_num);
        I0 = 1; I1 = 1;
        S0 = 0; S1 = 0;
        CE0 = 1; CE1 = 1;
        IGNORE0 = 1; IGNORE1 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: I0 and I1 both selected (behavior check)", test_num);
        I0 = 1; I1 = 1;
        S0 = 1; S1 = 1;
        CE0 = 1; CE1 = 1;
        IGNORE0 = 0; IGNORE1 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Select I1, CE1 active, but I1 is 0 and I0 is 1", test_num);
        I0 = 1; I1 = 0;
        S0 = 0; S1 = 1;
        CE0 = 0; CE1 = 1;
        IGNORE0 = 0; IGNORE1 = 0;
        #1;

        check_outputs(1'b0);
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
