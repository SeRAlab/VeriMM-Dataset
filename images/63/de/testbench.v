`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg SEL;
    reg VGND;
    reg VPWR;
    wire VOUT;
    wire VOUT_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .SEL(SEL),
        .VGND(VGND),
        .VPWR(VPWR),
        .VOUT(VOUT),
        .VOUT_N(VOUT_N)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: SEL=0 (Select A), A=0, B=1", test_num);
        A = 1'b0;
        B = 1'b1;
        SEL = 1'b0;
        VPWR = 1'b1;
        VGND = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: SEL=0 (Select A), A=1, B=0", test_num);
        A = 1'b1;
        B = 1'b0;
        SEL = 1'b0;
        VPWR = 1'b1;
        VGND = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: SEL=1 (Select B), A=1, B=0", test_num);
        A = 1'b1;
        B = 1'b0;
        SEL = 1'b1;
        VPWR = 1'b1;
        VGND = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: SEL=1 (Select B), A=0, B=1", test_num);
        A = 1'b0;
        B = 1'b1;
        SEL = 1'b1;
        VPWR = 1'b1;
        VGND = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: SEL=0, A=0, B=0", test_num);
        A = 1'b0;
        B = 1'b0;
        SEL = 1'b0;
        VPWR = 1'b1;
        VGND = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: SEL=0, A=1, B=1", test_num);
        A = 1'b1;
        B = 1'b1;
        SEL = 1'b0;
        VPWR = 1'b1;
        VGND = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: SEL=1, A=0, B=0", test_num);
        A = 1'b0;
        B = 1'b0;
        SEL = 1'b1;
        VPWR = 1'b1;
        VGND = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: SEL=1, A=1, B=1", test_num);
        A = 1'b1;
        B = 1'b1;
        SEL = 1'b1;
        VPWR = 1'b1;
        VGND = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_VOUT;
        input expected_VOUT_N;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_VOUT === (expected_VOUT ^ VOUT ^ expected_VOUT) &&
                expected_VOUT_N === (expected_VOUT_N ^ VOUT_N ^ expected_VOUT_N)) begin
                $display("PASS");
                $display("  Outputs: VOUT=%b, VOUT_N=%b",
                         VOUT, VOUT_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VOUT=%b, VOUT_N=%b",
                         expected_VOUT, expected_VOUT_N);
                $display("  Got:      VOUT=%b, VOUT_N=%b",
                         VOUT, VOUT_N);
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
