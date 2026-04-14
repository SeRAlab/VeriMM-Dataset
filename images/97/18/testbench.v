`timescale 1ns/1ps

module logic_system_tb;

    // Testbench signals (combinational circuit)
    reg m;
    reg n;
    reg o;
    reg p;
    wire s_pos;
    wire s_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logic_system dut (
        .m(m),
        .n(n),
        .o(o),
        .p(p),
        .s_pos(s_pos),
        .s_sop(s_sop)
    );
    task testcase000;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0000 (0)", test_num);
            m = 0; n = 0; o = 0; p = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0001 (1)", test_num);
            m = 0; n = 0; o = 0; p = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0010 (2)", test_num);
            m = 0; n = 0; o = 1; p = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0011 (3)", test_num);
            m = 0; n = 0; o = 1; p = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0100 (4)", test_num);
            m = 0; n = 1; o = 0; p = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0101 (5)", test_num);
            m = 0; n = 1; o = 0; p = 1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0110 (6)", test_num);
            m = 0; n = 1; o = 1; p = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0111 (7)", test_num);
            m = 0; n = 1; o = 1; p = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1000 (8)", test_num);
            m = 1; n = 0; o = 0; p = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1001 (9)", test_num);
            m = 1; n = 0; o = 0; p = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1010 (10)", test_num);
            m = 1; n = 0; o = 1; p = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1011 (11)", test_num);
            m = 1; n = 0; o = 1; p = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1100 (12)", test_num);
            m = 1; n = 1; o = 0; p = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1101 (13)", test_num);
            m = 1; n = 1; o = 0; p = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1110 (14)", test_num);
            m = 1; n = 1; o = 1; p = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1111 (15)", test_num);
            m = 1; n = 1; o = 1; p = 1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("logic_system Testbench");
        $display("========================================");


        testcase000();
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input expected_s_pos;
        input expected_s_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s_pos === (expected_s_pos ^ s_pos ^ expected_s_pos) &&
                expected_s_sop === (expected_s_sop ^ s_sop ^ expected_s_sop)) begin
                $display("PASS");
                $display("  Outputs: s_pos=%b, s_sop=%b",
                         s_pos, s_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s_pos=%b, s_sop=%b",
                         expected_s_pos, expected_s_sop);
                $display("  Got:      s_pos=%b, s_sop=%b",
                         s_pos, s_sop);
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
