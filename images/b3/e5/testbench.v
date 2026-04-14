`timescale 1ns/1ps

module combinational_logic_tb;

    // Testbench signals (combinational circuit)
    reg d;
    reg e;
    reg f;
    reg g;
    wire q_pos;
    wire q_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    combinational_logic dut (
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .q_pos(q_pos),
        .q_sop(q_sop)
    );
    task testcase001;

    begin
        test_num = 1;
        d = 1'b0; e = 1'b0; f = 1'b0; g = 1'b0;
        $display("Test %0d: Input d,e,f,g = 0,0,0,0 (Binary 0)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        d = 1'b0; e = 1'b0; f = 1'b0; g = 1'b1;
        $display("Test %0d: Input d,e,f,g = 0,0,0,1 (Binary 1)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        d = 1'b0; e = 1'b0; f = 1'b1; g = 1'b0;
        $display("Test %0d: Input d,e,f,g = 0,0,1,0 (Binary 2)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        d = 1'b0; e = 1'b0; f = 1'b1; g = 1'b1;
        $display("Test %0d: Input d,e,f,g = 0,0,1,1 (Binary 3)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        d = 1'b0; e = 1'b1; f = 1'b0; g = 1'b0;
        $display("Test %0d: Input d,e,f,g = 0,1,0,0 (Binary 4)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        d = 1'b0; e = 1'b1; f = 1'b0; g = 1'b1;
        $display("Test %0d: Input d,e,f,g = 0,1,0,1 (Binary 5)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        d = 1'b0; e = 1'b1; f = 1'b1; g = 1'b0;
        $display("Test %0d: Input d,e,f,g = 0,1,1,0 (Binary 6)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        d = 1'b0; e = 1'b1; f = 1'b1; g = 1'b1;
        $display("Test %0d: Input d,e,f,g = 0,1,1,1 (Binary 7)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        d = 1'b1; e = 1'b0; f = 1'b0; g = 1'b0;
        $display("Test %0d: Input d,e,f,g = 1,0,0,0 (Binary 8)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        d = 1'b1; e = 1'b0; f = 1'b0; g = 1'b1;
        $display("Test %0d: Input d,e,f,g = 1,0,0,1 (Binary 9)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        d = 1'b1; e = 1'b0; f = 1'b1; g = 1'b0;
        $display("Test %0d: Input d,e,f,g = 1,0,1,0 (Binary 10)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        d = 1'b1; e = 1'b0; f = 1'b1; g = 1'b1;
        $display("Test %0d: Input d,e,f,g = 1,0,1,1 (Binary 11)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        d = 1'b1; e = 1'b1; f = 1'b0; g = 1'b0;
        $display("Test %0d: Input d,e,f,g = 1,1,0,0 (Binary 12)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        d = 1'b1; e = 1'b1; f = 1'b0; g = 1'b1;
        $display("Test %0d: Input d,e,f,g = 1,1,0,1 (Binary 13)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        d = 1'b1; e = 1'b1; f = 1'b1; g = 1'b0;
        $display("Test %0d: Input d,e,f,g = 1,1,1,0 (Binary 14)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        d = 1'b1; e = 1'b1; f = 1'b1; g = 1'b1;
        $display("Test %0d: Input d,e,f,g = 1,1,1,1 (Binary 15)", test_num);
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
        $display("combinational_logic Testbench");
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
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_q_pos;
        input expected_q_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q_pos === (expected_q_pos ^ q_pos ^ expected_q_pos) &&
                expected_q_sop === (expected_q_sop ^ q_sop ^ expected_q_sop)) begin
                $display("PASS");
                $display("  Outputs: q_pos=%b, q_sop=%b",
                         q_pos, q_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_pos=%b, q_sop=%b",
                         expected_q_pos, expected_q_sop);
                $display("  Got:      q_pos=%b, q_sop=%b",
                         q_pos, q_sop);
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
