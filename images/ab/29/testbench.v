`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg CE;
    reg CLK;
    reg D;
    wire Q;
    wire Q15;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .CE(CE),
        .CLK(CLK),
        .D(D),
        .Q(Q),
        .Q15(Q15)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CE = 1;
            D = 0;
            A3 = 0; A2 = 0; A1 = 0; A0 = 0;
            repeat(16) @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift single '1' to Q15", test_num);
            reset_dut();


            @(negedge CLK);
            D = 1; CE = 1;
            @(negedge CLK);
            D = 0;


            repeat(15) @(negedge CLK);


            A3=1; A2=1; A1=1; A0=1;
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check tap A=0 (first stage)", test_num);
            reset_dut();


            @(negedge CLK);
            D = 1; CE = 1;
            @(negedge CLK);
            CE = 0;


            A3=0; A2=0; A1=0; A0=0;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clock Enable (CE) check", test_num);
            reset_dut();


            @(negedge CLK);
            D = 1; CE = 1;
            @(negedge CLK);


            D = 0; CE = 0;
            repeat(5) @(negedge CLK);


            A3=0; A2=0; A1=0; A0=0;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Intermediate tap A=7", test_num);
            reset_dut();


            @(negedge CLK);
            D = 1; CE = 1;
            repeat(7) begin
                @(negedge CLK);
                D = 0;
            end
            @(negedge CLK);


            A3=0; A2=1; A1=1; A0=1;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        reg [15:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full 16-bit pattern shift", test_num);
            reset_dut();

            pattern = 16'hA5A5;


            CE = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(negedge CLK);
                D = pattern[i];
            end





            A3=1; A2=1; A1=1; A0=1;
            #2;
            #1;

            check_outputs(pattern[0], pattern[0]);
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
        input expected_Q;
        input expected_Q15;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q15 === (expected_Q15 ^ Q15 ^ expected_Q15)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q15=%b",
                         Q, Q15);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q15=%b",
                         expected_Q, expected_Q15);
                $display("  Got:      Q=%b, Q15=%b",
                         Q, Q15);
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
        $dumpvars(0,A0, A1, A2, A3, CE, CLK, D, Q, Q15);
    end

endmodule
