`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] AD;
    reg ALOAD;
    reg CLK;
    reg [1:0] D;
    wire [1:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AD(AD),
        .ALOAD(ALOAD),
        .CLK(CLK),
        .D(D),
        .Q(Q)
    );

        task reset_dut;

    begin
        CLK = 0;
        ALOAD = 1;
        AD = 2'b00;
        D = 2'b00;
        #10;
        ALOAD = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Asynchronous Load", test_num);
        ALOAD = 1;
        AD = 2'b11;
        #5;

        #1;


        check_outputs(2'b11);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Synchronous Load on Rising Edge", test_num);
        ALOAD = 0;
        D = 2'b10;
        #5;
        CLK = 1;
        #5;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: ALOAD Priority Over CLK/D", test_num);
        ALOAD = 1;
        AD = 2'b01;
        D = 2'b11;
        #5;
        CLK = 1;
        #5;
        CLK = 0;

        #1;


        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Data Hold (No Clock Edge)", test_num);

        ALOAD = 0;
        D = 2'b11;
        #5;
        CLK = 1;
        #5;
        CLK = 0;

        D = 2'b00;
        #10;

        #1;


        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Transition Async to Sync", test_num);

        ALOAD = 1;
        AD = 2'b10;
        #5;

        ALOAD = 0;
        #5;

        D = 2'b01;
        #5;
        CLK = 1;
        #5;
        #1;

        check_outputs(2'b01);
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
        input [1:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,AD, ALOAD, CLK, D, Q);
    end

endmodule
