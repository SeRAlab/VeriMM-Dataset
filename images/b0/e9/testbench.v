`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg reqin1;
    reg reqin2;
    wire reqout1;
    wire reqout2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reqin1(reqin1),
        .reqin2(reqin2),
        .reqout1(reqout1),
        .reqout2(reqout2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Idle State (No Requests)", test_num);
            reqin1 = 0;
            reqin2 = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Request 1 Only", test_num);

            reqin1 = 0; reqin2 = 0; #10;

            reqin1 = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Request 2 Only", test_num);

            reqin1 = 0; reqin2 = 0; #10;

            reqin2 = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Mutual Exclusion (Req1 active, then Req2 arrives)", test_num);

            reqin1 = 0; reqin2 = 0; #10;

            reqin1 = 1;
            #10;

            reqin2 = 1;
            #10;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Mutual Exclusion (Req2 active, then Req1 arrives)", test_num);

            reqin1 = 0; reqin2 = 0; #10;

            reqin2 = 1;
            #10;

            reqin1 = 1;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Handover (Req1 releases while Req2 is waiting)", test_num);

            reqin1 = 0; reqin2 = 0; #10;

            reqin1 = 1;
            #5;
            reqin2 = 1;
            #10;

            reqin1 = 0;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Handover (Req2 releases while Req1 is waiting)", test_num);

            reqin1 = 0; reqin2 = 0; #10;

            reqin2 = 1;
            #5;
            reqin1 = 1;
            #10;

            reqin2 = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Release All", test_num);

            reqin1 = 1; reqin2 = 1; #10;

            reqin1 = 0; reqin2 = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_reqout1;
        input expected_reqout2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_reqout1 === (expected_reqout1 ^ reqout1 ^ expected_reqout1) &&
                expected_reqout2 === (expected_reqout2 ^ reqout2 ^ expected_reqout2)) begin
                $display("PASS");
                $display("  Outputs: reqout1=%b, reqout2=%b",
                         reqout1, reqout2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reqout1=%b, reqout2=%b",
                         expected_reqout1, expected_reqout2);
                $display("  Got:      reqout1=%b, reqout2=%b",
                         reqout1, reqout2);
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
