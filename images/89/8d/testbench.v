`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg A4;
    reg D0;
    reg D1;
    reg WCLK;
    reg WE;
    wire O0;
    wire O1;

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
        .A4(A4),
        .D0(D0),
        .D1(D1),
        .WCLK(WCLK),
        .WE(WE),
        .O0(O0),
        .O1(O1)
    );

        task reset_dut;

        begin
            A0 = 0;
            A1 = 0;
            A2 = 0;
            A3 = 0;
            A4 = 0;
            D0 = 0;
            D1 = 0;
            WCLK = 0;
            WE = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Basic Write and Read at Address 0");
            reset_dut();


            {A4, A3, A2, A1, A0} = 5'b00000;
            {D1, D0} = 2'b11;
            WE = 1;
            #10;
            WCLK = 1;
            #10;
            WCLK = 0;
            WE = 0;
            #10;


            {A4, A3, A2, A1, A0} = 5'b00000;
            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Write and Read at Address 31");
            reset_dut();


            {A4, A3, A2, A1, A0} = 5'b11111;
            {D1, D0} = 2'b01;
            WE = 1;
            #10;
            WCLK = 1;
            #10;
            WCLK = 0;
            WE = 0;
            #10;


            {A4, A3, A2, A1, A0} = 5'b11111;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Verify WE prevents writing when low");
            reset_dut();


            {A4, A3, A2, A1, A0} = 5'd10;
            {D1, D0} = 2'b10;
            WE = 1;
            #10; WCLK = 1; #10; WCLK = 0; WE = 0;


            {A4, A3, A2, A1, A0} = 5'd10;
            {D1, D0} = 2'b11;
            WE = 0;
            #10; WCLK = 1; #10; WCLK = 0;


            {A4, A3, A2, A1, A0} = 5'd10;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Multiple address data independence");
            reset_dut();


            {A4, A3, A2, A1, A0} = 5'd5;
            {D1, D0} = 2'b01;
            WE = 1;
            #10; WCLK = 1; #10; WCLK = 0;


            {A4, A3, A2, A1, A0} = 5'd20;
            {D1, D0} = 2'b10;
            WE = 1;
            #10; WCLK = 1; #10; WCLK = 0;
            WE = 0;


            {A4, A3, A2, A1, A0} = 5'd5;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Overwriting existing data");
            reset_dut();


            {A4, A3, A2, A1, A0} = 5'd15;
            {D1, D0} = 2'b00;
            WE = 1; #10; WCLK = 1; #10; WCLK = 0;


            {A4, A3, A2, A1, A0} = 5'd15;
            {D1, D0} = 2'b11;
            WE = 1; #10; WCLK = 1; #10; WCLK = 0;
            WE = 0;


            {A4, A3, A2, A1, A0} = 5'd15;
            #10;
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
        input expected_O0;
        input expected_O1;
        begin
            if (expected_O0 === (expected_O0 ^ O0 ^ expected_O0) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1)) begin
                $display("PASS");
                $display("  Outputs: O0=%b, O1=%b",
                         O0, O1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O0=%b, O1=%b",
                         expected_O0, expected_O1);
                $display("  Got:      O0=%b, O1=%b",
                         O0, O1);
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
        $dumpvars(0,A0, A1, A2, A3, A4, D0, D1, WCLK, WE, O0, O1);
    end

endmodule
