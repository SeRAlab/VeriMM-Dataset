`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] I0;
    reg [3:0] I1;
    reg S;
    wire [3:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I0(I0),
        .I1(I1),
        .S(S),
        .O(O)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: S=0, I0=4'h5, I1=4'hA", test_num);
        I0 = 4'h5;
        I1 = 4'hA;
        S = 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: S=1, I0=4'h5, I1=4'hA", test_num);
        I0 = 4'h5;
        I1 = 4'hA;
        S = 1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: S=0, I0=4'hF, I1=4'h0", test_num);
        I0 = 4'hF;
        I1 = 4'h0;
        S = 0;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: S=1, I0=4'hF, I1=4'h0", test_num);
        I0 = 4'hF;
        I1 = 4'h0;
        S = 1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: S=0, I0=4'hC, I1=4'h3", test_num);
        I0 = 4'hC;
        I1 = 4'h3;
        S = 0;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: S=1, I0=4'hC, I1=4'h3", test_num);
        I0 = 4'hC;
        I1 = 4'h3;
        S = 1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: S=0, I0=4'h9, I1=4'h6", test_num);
        I0 = 4'h9;
        I1 = 4'h6;
        S = 0;
        #1;

        check_outputs(4'h9);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: S=1, I0=4'h9, I1=4'h6", test_num);
        I0 = 4'h9;
        I1 = 4'h6;
        S = 1;
        #1;

        check_outputs(4'h6);
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
        input [3:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
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
