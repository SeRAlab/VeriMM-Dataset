`timescale 1ns/1ps

module logic_circuit_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    wire p_pos;
    wire p_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logic_circuit dut (
        .a(a),
        .b(b),
        .c(c),
        .p_pos(p_pos),
        .p_sop(p_sop)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: abc = 000 (Decimal 0)", test_num);
        a = 1'b0; b = 1'b0; c = 1'b0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: abc = 001 (Decimal 1)", test_num);
        a = 1'b0; b = 1'b0; c = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: abc = 010 (Decimal 2)", test_num);
        a = 1'b0; b = 1'b1; c = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: abc = 011 (Decimal 3)", test_num);
        a = 1'b0; b = 1'b1; c = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: abc = 100 (Decimal 4)", test_num);
        a = 1'b1; b = 1'b0; c = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: abc = 101 (Decimal 5)", test_num);
        a = 1'b1; b = 1'b0; c = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: abc = 110 (Decimal 6)", test_num);
        a = 1'b1; b = 1'b1; c = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: abc = 111 (Decimal 7)", test_num);
        a = 1'b1; b = 1'b1; c = 1'b1;
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
        $display("logic_circuit Testbench");
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
        input expected_p_pos;
        input expected_p_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p_pos === (expected_p_pos ^ p_pos ^ expected_p_pos) &&
                expected_p_sop === (expected_p_sop ^ p_sop ^ expected_p_sop)) begin
                $display("PASS");
                $display("  Outputs: p_pos=%b, p_sop=%b",
                         p_pos, p_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p_pos=%b, p_sop=%b",
                         expected_p_pos, expected_p_sop);
                $display("  Got:      p_pos=%b, p_sop=%b",
                         p_pos, p_sop);
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
