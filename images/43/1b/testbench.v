`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_24M;
    reg RESETP;
    wire CLK_24MB;
    wire LSPC_12M;
    wire LSPC_1_5M;
    wire LSPC_3M;
    wire LSPC_4M;
    wire LSPC_6M;
    wire LSPC_8M;
    wire Q53_CO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_24M(CLK_24M),
        .RESETP(RESETP),
        .CLK_24MB(CLK_24MB),
        .LSPC_12M(LSPC_12M),
        .LSPC_1_5M(LSPC_1_5M),
        .LSPC_3M(LSPC_3M),
        .LSPC_4M(LSPC_4M),
        .LSPC_6M(LSPC_6M),
        .LSPC_8M(LSPC_8M),
        .Q53_CO(Q53_CO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_24M = 0;
        forever #5 CLK_24M = ~CLK_24M;
    end

        task reset_dut;

        begin
            RESETP = 1;
            repeat(5) @(posedge CLK_24M);
            #2;
            RESETP = 0;
            @(posedge CLK_24M);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State Check", test_num);
            reset_dut();


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State after 1st Clock Pulse", test_num);
            reset_dut();
            repeat(1) @(posedge CLK_24M);
            #7;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State after 4 Clock Pulses", test_num);
            reset_dut();
            repeat(4) @(posedge CLK_24M);
            #7;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State after 16 Clock Pulses", test_num);
            reset_dut();
            repeat(16) @(posedge CLK_24M);
            #7;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asynchronous Reset Interruption", test_num);
            reset_dut();
            repeat(10) @(posedge CLK_24M);
            RESETP = 1;
            #3;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
            RESETP = 0;
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
        input expected_CLK_24MB;
        input expected_LSPC_12M;
        input expected_LSPC_1_5M;
        input expected_LSPC_3M;
        input expected_LSPC_4M;
        input expected_LSPC_6M;
        input expected_LSPC_8M;
        input expected_Q53_CO;
        begin
            if (expected_CLK_24MB === (expected_CLK_24MB ^ CLK_24MB ^ expected_CLK_24MB) &&
                expected_LSPC_12M === (expected_LSPC_12M ^ LSPC_12M ^ expected_LSPC_12M) &&
                expected_LSPC_1_5M === (expected_LSPC_1_5M ^ LSPC_1_5M ^ expected_LSPC_1_5M) &&
                expected_LSPC_3M === (expected_LSPC_3M ^ LSPC_3M ^ expected_LSPC_3M) &&
                expected_LSPC_4M === (expected_LSPC_4M ^ LSPC_4M ^ expected_LSPC_4M) &&
                expected_LSPC_6M === (expected_LSPC_6M ^ LSPC_6M ^ expected_LSPC_6M) &&
                expected_LSPC_8M === (expected_LSPC_8M ^ LSPC_8M ^ expected_LSPC_8M) &&
                expected_Q53_CO === (expected_Q53_CO ^ Q53_CO ^ expected_Q53_CO)) begin
                $display("PASS");
                $display("  Outputs: CLK_24MB=%b, LSPC_12M=%b, LSPC_1_5M=%b, LSPC_3M=%b, LSPC_4M=%b, LSPC_6M=%b, LSPC_8M=%b, Q53_CO=%b",
                         CLK_24MB, LSPC_12M, LSPC_1_5M, LSPC_3M, LSPC_4M, LSPC_6M, LSPC_8M, Q53_CO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLK_24MB=%b, LSPC_12M=%b, LSPC_1_5M=%b, LSPC_3M=%b, LSPC_4M=%b, LSPC_6M=%b, LSPC_8M=%b, Q53_CO=%b",
                         expected_CLK_24MB, expected_LSPC_12M, expected_LSPC_1_5M, expected_LSPC_3M, expected_LSPC_4M, expected_LSPC_6M, expected_LSPC_8M, expected_Q53_CO);
                $display("  Got:      CLK_24MB=%b, LSPC_12M=%b, LSPC_1_5M=%b, LSPC_3M=%b, LSPC_4M=%b, LSPC_6M=%b, LSPC_8M=%b, Q53_CO=%b",
                         CLK_24MB, LSPC_12M, LSPC_1_5M, LSPC_3M, LSPC_4M, LSPC_6M, LSPC_8M, Q53_CO);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,CLK_24M, RESETP, CLK_24MB, LSPC_12M, LSPC_1_5M, LSPC_3M, LSPC_4M, LSPC_6M, LSPC_8M, Q53_CO);
    end

endmodule
