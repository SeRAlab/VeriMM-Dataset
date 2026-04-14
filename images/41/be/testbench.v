`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg DDRDEL;
    reg DIRECTION;
    reg LOADN;
    reg MOVE;
    wire CFLAG;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .DDRDEL(DDRDEL),
        .DIRECTION(DIRECTION),
        .LOADN(LOADN),
        .MOVE(MOVE),
        .CFLAG(CFLAG),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        DDRDEL = 0;
        forever #5 DDRDEL = ~DDRDEL;
    end

        task reset_dut;

    begin
        A = 0;
        LOADN = 1;
        MOVE = 0;
        DIRECTION = 0;

        repeat(2) @(negedge DDRDEL);
        LOADN = 0;
        repeat(2) @(negedge DDRDEL);
        LOADN = 1;
        @(negedge DDRDEL);
        $display("DUT Reset Complete");
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Basic Load and Passthrough", test_num);
        reset_dut();

        A = 1;
        LOADN = 0;
        repeat(2) @(negedge DDRDEL);
        LOADN = 1;



        wait(DDRDEL == 0);
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Shift Move with Direction 1", test_num);
        reset_dut();

        A = 1;
        MOVE = 1;
        DIRECTION = 1;
        LOADN = 1;

        repeat(5) @(negedge DDRDEL);


        wait(DDRDEL == 0);
        #2;


        #1;



        check_outputs(CFLAG, Z);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Shift Move with Direction 0", test_num);
        reset_dut();

        A = 0;
        MOVE = 1;
        DIRECTION = 0;
        LOADN = 1;

        repeat(10) @(negedge DDRDEL);

        wait(DDRDEL == 1);
        #2;
        #1;

        check_outputs(CFLAG, Z);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Carry Flag Observation", test_num);
        reset_dut();


        A = 1;
        LOADN = 0;
        repeat(2) @(negedge DDRDEL);
        LOADN = 1;
        MOVE = 1;
        DIRECTION = 1;

        repeat(16) @(negedge DDRDEL);

        wait(DDRDEL == 0);
        #2;
        #1;

        check_outputs(CFLAG, Z);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Static Register with Toggling Input", test_num);
        reset_dut();

        MOVE = 0;
        A = 1;
        repeat(2) @(negedge DDRDEL);
        A = 0;
        repeat(2) @(negedge DDRDEL);
        A = 1;

        #2;

        if (DDRDEL == 0)
            #1;

            check_outputs(CFLAG, 1'b1);
        else
            #1;

            check_outputs(CFLAG, Z);
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
        input expected_CFLAG;
        input expected_Z;
        begin
            if (expected_CFLAG === (expected_CFLAG ^ CFLAG ^ expected_CFLAG) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: CFLAG=%b, Z=%b",
                         CFLAG, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CFLAG=%b, Z=%b",
                         expected_CFLAG, expected_Z);
                $display("  Got:      CFLAG=%b, Z=%b",
                         CFLAG, Z);
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
        $dumpvars(0,A, DDRDEL, DIRECTION, LOADN, MOVE, CFLAG, Z);
    end

endmodule
