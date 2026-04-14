`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ai;
    reg bi;
    reg ci;
    wire ao;
    wire bo;
    wire co;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ai(ai),
        .bi(bi),
        .ci(ci),
        .ao(ao),
        .bo(bo),
        .co(co)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: ai=0, bi=0, ci=0", test_num);
            ai = 1'b0; bi = 1'b0; ci = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: ai=0, bi=0, ci=1", test_num);
            ai = 1'b0; bi = 1'b0; ci = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: ai=0, bi=1, ci=0", test_num);
            ai = 1'b0; bi = 1'b1; ci = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: ai=0, bi=1, ci=1", test_num);
            ai = 1'b0; bi = 1'b1; ci = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: ai=1, bi=0, ci=0", test_num);
            ai = 1'b1; bi = 1'b0; ci = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: ai=1, bi=0, ci=1", test_num);
            ai = 1'b1; bi = 1'b0; ci = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: ai=1, bi=1, ci=0", test_num);
            ai = 1'b1; bi = 1'b1; ci = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: ai=1, bi=1, ci=1", test_num);
            ai = 1'b1; bi = 1'b1; ci = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
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
        input expected_ao;
        input expected_bo;
        input expected_co;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ao === (expected_ao ^ ao ^ expected_ao) &&
                expected_bo === (expected_bo ^ bo ^ expected_bo) &&
                expected_co === (expected_co ^ co ^ expected_co)) begin
                $display("PASS");
                $display("  Outputs: ao=%b, bo=%b, co=%b",
                         ao, bo, co);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ao=%b, bo=%b, co=%b",
                         expected_ao, expected_bo, expected_co);
                $display("  Got:      ao=%b, bo=%b, co=%b",
                         ao, bo, co);
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
