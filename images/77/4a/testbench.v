`timescale 1ns/1ps

module boolean_logic_tb;

    // Testbench signals (combinational circuit)
    reg u;
    reg v;
    reg w;
    wire r_pos;
    wire r_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    boolean_logic dut (
        .u(u),
        .v(v),
        .w(w),
        .r_pos(r_pos),
        .r_sop(r_sop)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Input 000 (0)", test_num);
            u = 0; v = 0; w = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Input 001 (1)", test_num);
            u = 0; v = 0; w = 1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Input 010 (2)", test_num);
            u = 0; v = 1; w = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Input 011 (3)", test_num);
            u = 0; v = 1; w = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Input 100 (4)", test_num);
            u = 1; v = 0; w = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Input 101 (5)", test_num);
            u = 1; v = 0; w = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Input 110 (6)", test_num);
            u = 1; v = 1; w = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Input 111 (7)", test_num);
            u = 1; v = 1; w = 1;
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
        $display("boolean_logic Testbench");
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
        input expected_r_pos;
        input expected_r_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r_pos === (expected_r_pos ^ r_pos ^ expected_r_pos) &&
                expected_r_sop === (expected_r_sop ^ r_sop ^ expected_r_sop)) begin
                $display("PASS");
                $display("  Outputs: r_pos=%b, r_sop=%b",
                         r_pos, r_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r_pos=%b, r_sop=%b",
                         expected_r_pos, expected_r_sop);
                $display("  Got:      r_pos=%b, r_sop=%b",
                         r_pos, r_sop);
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
