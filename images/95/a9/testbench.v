`timescale 1ns/1ps

module state_logic_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] q;
    reg r;
    wire Q2;
    wire Q3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_logic dut (
        .q(q),
        .r(r),
        .Q2(Q2),
        .Q3(Q3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: State M (0001), r=0 -> Expect Q2=1, Q3=0 (Next State N)", test_num);
            q = 4'b0001;
            r = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: State M (0001), r=1 -> Expect Q2=0, Q3=1 (Next State O)", test_num);
            q = 4'b0001;
            r = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: State N (0010), r=0 -> Expect Q2=0, Q3=0 (Next State M)", test_num);
            q = 4'b0010;
            r = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State N (0010), r=1 -> Expect Q2=0, Q3=0 (Next State P)", test_num);
            q = 4'b0010;
            r = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: State O (0100), r=0 -> Expect Q2=0, Q3=0 (Next State P)", test_num);
            q = 4'b0100;
            r = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: State O (0100), r=1 -> Expect Q2=0, Q3=0 (Next State M)", test_num);
            q = 4'b0100;
            r = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: State P (1000), r=0 -> Expect Q2=1, Q3=0 (Next State N)", test_num);
            q = 4'b1000;
            r = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: State P (1000), r=1 -> Expect Q2=0, Q3=1 (Next State O)", test_num);
            q = 4'b1000;
            r = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: All inputs zero (Invalid One-Hot) -> Expect Q2=0, Q3=0", test_num);
            q = 4'b0000;
            r = 0;
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
        $display("state_logic Testbench");
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
        input expected_Q2;
        input expected_Q3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q2 === (expected_Q2 ^ Q2 ^ expected_Q2) &&
                expected_Q3 === (expected_Q3 ^ Q3 ^ expected_Q3)) begin
                $display("PASS");
                $display("  Outputs: Q2=%b, Q3=%b",
                         Q2, Q3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q2=%b, Q3=%b",
                         expected_Q2, expected_Q3);
                $display("  Got:      Q2=%b, Q3=%b",
                         Q2, Q3);
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
