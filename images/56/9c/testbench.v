`timescale 1ns/1ps

module digital_system_tb;

    // Testbench signals (combinational circuit)
    reg w;
    reg x;
    reg y;
    reg z;
    wire n_pos;
    wire n_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    digital_system dut (
        .w(w),
        .x(x),
        .y(y),
        .z(z),
        .n_pos(n_pos),
        .n_sop(n_sop)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Binary value 0 (0000) - Expected 0", test_num);
            x = 0; y = 0; z = 0; w = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Binary value 1 (0001) - Expected 1", test_num);
            x = 0; y = 0; z = 0; w = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Binary value 2 (0010) - Expected 0", test_num);
            x = 0; y = 0; z = 1; w = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Binary value 4 (0100) - Expected 1", test_num);
            x = 0; y = 1; z = 0; w = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Binary value 7 (0111) - Expected 0", test_num);
            x = 0; y = 1; z = 1; w = 1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Binary value 8 (1000) - Expected 1", test_num);
            x = 1; y = 0; z = 0; w = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Binary value 10 (1010) - Expected 0", test_num);
            x = 1; y = 0; z = 1; w = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Binary value 14 (1110) - Expected 1", test_num);
            x = 1; y = 1; z = 1; w = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Binary value 15 (1111) - Expected 0", test_num);
            x = 1; y = 1; z = 1; w = 1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("digital_system Testbench");
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
        input expected_n_pos;
        input expected_n_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n_pos === (expected_n_pos ^ n_pos ^ expected_n_pos) &&
                expected_n_sop === (expected_n_sop ^ n_sop ^ expected_n_sop)) begin
                $display("PASS");
                $display("  Outputs: n_pos=%b, n_sop=%b",
                         n_pos, n_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n_pos=%b, n_sop=%b",
                         expected_n_pos, expected_n_sop);
                $display("  Got:      n_pos=%b, n_sop=%b",
                         n_pos, n_sop);
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
