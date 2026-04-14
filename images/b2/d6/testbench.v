`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg D;
    reg WCLK;
    reg WE;
    wire O;

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
        .D(D),
        .WCLK(WCLK),
        .WE(WE),
        .O(O)
    );

        task reset_dut;

        begin

            A0 = 0; A1 = 0; A2 = 0; A3 = 0;
            D = 0; WCLK = 0; WE = 0;
            #10;

            for (i = 0; i < 16; i = i + 1) begin
                write_mem(i, 0);
            end
            #10;
        end
        endtask
    task pulse_clk;

        begin
            #5 WCLK = 1;
            #5 WCLK = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Write 1 to Address 0 and Read back", test_num);
            write_mem(4'b0000, 1);
            {A3, A2, A1, A0} = 4'b0000;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Write 1 to Address 15 and Read back", test_num);
            write_mem(4'b1111, 1);
            {A3, A2, A1, A0} = 4'b1111;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Attempt Write with WE=0", test_num);
            {A3, A2, A1, A0} = 4'b0101;
            D = 1;
            WE = 0;
            pulse_clk();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Overwrite Address 10 from 1 to 0", test_num);
            write_mem(4'b1010, 1);
            write_mem(4'b1010, 0);
            {A3, A2, A1, A0} = 4'b1010;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Address Isolation Check", test_num);
            write_mem(4'b0001, 1);
            write_mem(4'b0010, 0);
            {A3, A2, A1, A0} = 4'b0001;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Address Bit A3 Check", test_num);
            write_mem(4'b1000, 1);
            {A3, A2, A1, A0} = 4'b1000;
            #5;
            #1;

            check_outputs(1'b1);
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
        input expected_O;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%b",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%b",
                         expected_O);
                $display("  Got:      O=%b",
                         O);
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
        $dumpvars(0,A0, A1, A2, A3, D, WCLK, WE, O);
    end

endmodule
