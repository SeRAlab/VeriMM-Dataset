`timescale 1ns/1ps

module fsm_state_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] n;
    reg r;
    wire N2;
    wire N3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_state dut (
        .n(n),
        .r(r),
        .N2(N2),
        .N3(N3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: State I, r=0", test_num);
            n = 4'b0001;
            r = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: State I, r=1", test_num);
            n = 4'b0001;
            r = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: State J, r=0", test_num);
            n = 4'b0010;
            r = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: State J, r=1", test_num);
            n = 4'b0010;
            r = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: State K, r=0", test_num);
            n = 4'b0100;
            r = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: State K, r=1", test_num);
            n = 4'b0100;
            r = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: State L, r=0", test_num);
            n = 4'b1000;
            r = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: State L, r=1", test_num);
            n = 4'b1000;
            r = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm_state Testbench");
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
        input expected_N2;
        input expected_N3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_N2 === (expected_N2 ^ N2 ^ expected_N2) &&
                expected_N3 === (expected_N3 ^ N3 ^ expected_N3)) begin
                $display("PASS");
                $display("  Outputs: N2=%b, N3=%b",
                         N2, N3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: N2=%b, N3=%b",
                         expected_N2, expected_N3);
                $display("  Got:      N2=%b, N3=%b",
                         N2, N3);
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
