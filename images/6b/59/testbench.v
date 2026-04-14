`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Allow;
    reg [3:0] P1;
    reg [3:0] P2;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Allow(Allow),
        .P1(P1),
        .P2(P2),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allow=0, P1=5, P2=3", test_num);
            Allow = 1'b0;
            P1 = 4'd5;
            P2 = 4'd3;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allow=1, P1=4, P2=2", test_num);
            Allow = 1'b1;
            P1 = 4'd4;
            P2 = 4'd2;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allow=1, P1=10, P2=10 (Overflow)", test_num);
            Allow = 1'b1;
            P1 = 4'd10;
            P2 = 4'd10;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allow=0, P1=15, P2=15", test_num);
            Allow = 1'b0;
            P1 = 4'hF;
            P2 = 4'hF;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allow=1, P1=15, P2=15 (Max sum overflow)", test_num);
            Allow = 1'b1;
            P1 = 4'hF;
            P2 = 4'hF;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allow=1, P1=7, P2=0", test_num);
            Allow = 1'b1;
            P1 = 4'd7;
            P2 = 4'd0;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allow=1, P1=15, P2=1", test_num);
            Allow = 1'b1;
            P1 = 4'hF;
            P2 = 4'h1;
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
