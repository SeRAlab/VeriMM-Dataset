`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg D0;
    reg D1;
    reg D2;
    reg D3;
    reg WCLK;
    reg WE;
    wire O0;
    wire O1;
    wire O2;
    wire O3;

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
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .WCLK(WCLK),
        .WE(WE),
        .O0(O0),
        .O1(O1),
        .O2(O2),
        .O3(O3)
    );

        task reset_dut;

        begin
            A0 = 0; A1 = 0; A2 = 0; A3 = 0;
            D0 = 0; D1 = 0; D2 = 0; D3 = 0;
            WCLK = 0;
            WE = 0;
            #10;
        end
        endtask
    task write_data;

        input [3:0] addr;
        input [3:0] data;
        begin
            {A3, A2, A1, A0} = addr;
            {D3, D2, D1, D0} = data;
            WE = 1;
            #5;
            WCLK = 1;
            #5;
            WCLK = 0;
            WE = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Write 4'b1010 to Address 0");
            reset_dut();
            write_data(4'h0, 4'b1010);
            {A3, A2, A1, A0} = 4'h0;
            #5;
            #1;

            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write 4'b0101 to Address 15");
            reset_dut();
            write_data(4'hF, 4'b0101);
            {A3, A2, A1, A0} = 4'hF;
            #5;
            #1;

            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write 4'b1111 to Address 7");
            reset_dut();
            write_data(4'h7, 4'b1111);
            {A3, A2, A1, A0} = 4'h7;
            #5;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify WE=0 prevents writing");
            reset_dut();

            write_data(4'h2, 4'b1000);


            {A3, A2, A1, A0} = 4'h2;
            {D3, D2, D1, D0} = 4'b0001;
            WE = 0;
            #5;
            WCLK = 1;
            #5;
            WCLK = 0;
            #5;


            #1;



            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwrite Address 12");
            reset_dut();
            write_data(4'hC, 4'b0011);
            write_data(4'hC, 4'b1100);
            {A3, A2, A1, A0} = 4'hC;
            #5;
            #1;

            check_outputs(0, 0, 1, 1);
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
        input expected_O2;
        input expected_O3;
        begin
            if (expected_O0 === (expected_O0 ^ O0 ^ expected_O0) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1) &&
                expected_O2 === (expected_O2 ^ O2 ^ expected_O2) &&
                expected_O3 === (expected_O3 ^ O3 ^ expected_O3)) begin
                $display("PASS");
                $display("  Outputs: O0=%b, O1=%b, O2=%b, O3=%b",
                         O0, O1, O2, O3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O0=%b, O1=%b, O2=%b, O3=%b",
                         expected_O0, expected_O1, expected_O2, expected_O3);
                $display("  Got:      O0=%b, O1=%b, O2=%b, O3=%b",
                         O0, O1, O2, O3);
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
        $dumpvars(0,A0, A1, A2, A3, D0, D1, D2, D3, WCLK, WE, O0, O1, O2, O3);
    end

endmodule
