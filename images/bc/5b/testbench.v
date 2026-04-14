`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg I0;
    reg I1;
    reg [3:0] INIT;
    wire O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I0(I0),
        .I1(I1),
        .INIT(INIT),
        .O(O)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND Gate Logic (INIT=1000)", test_num);
            INIT = 4'b1000;


            I1 = 0; I0 = 0;
            #1;

            check_outputs(1'b0);


            I1 = 0; I0 = 1;
            #1;

            check_outputs(1'b0);


            I1 = 1; I0 = 0;
            #1;

            check_outputs(1'b0);


            I1 = 1; I0 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: OR Gate Logic (INIT=1110)", test_num);
            INIT = 4'b1110;

            I1 = 0; I0 = 0;
            #1;

            check_outputs(1'b0);

            I1 = 0; I0 = 1;
            #1;

            check_outputs(1'b1);

            I1 = 1; I0 = 0;
            #1;

            check_outputs(1'b1);

            I1 = 1; I0 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR Gate Logic (INIT=0110)", test_num);
            INIT = 4'b0110;

            I1 = 0; I0 = 0;
            #1;

            check_outputs(1'b0);

            I1 = 0; I0 = 1;
            #1;

            check_outputs(1'b1);

            I1 = 1; I0 = 0;
            #1;

            check_outputs(1'b1);

            I1 = 1; I0 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Constant High (INIT=1111)", test_num);
            INIT = 4'b1111;

            I1 = 0; I0 = 0;
            #1;

            check_outputs(1'b1);

            I1 = 1; I0 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit Selection Sweep", test_num);


            INIT = 4'b0001; I1 = 0; I0 = 0;
            #1;

            check_outputs(1'b1);


            INIT = 4'b0010; I1 = 0; I0 = 1;
            #1;

            check_outputs(1'b1);


            INIT = 4'b0100; I1 = 1; I0 = 0;
            #1;

            check_outputs(1'b1);


            INIT = 4'b1000; I1 = 1; I0 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inverter on I0 (INIT=0101)", test_num);
            INIT = 4'b0101;

            I1 = 0; I0 = 0;
            #1;

            check_outputs(1'b1);

            I1 = 0; I0 = 1;
            #1;

            check_outputs(1'b0);

            I1 = 1; I0 = 0;
            #1;

            check_outputs(1'b1);

            I1 = 1; I0 = 1;
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
