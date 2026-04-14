`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CTRL;
    reg [3:0] P;
    reg PL;
    reg SI;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CTRL(CTRL),
        .P(P),
        .PL(PL),
        .SI(SI),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            PL = 1;
            P = 4'b0000;
            CTRL = 0;
            SI = 0;
            @(posedge CLK);
            #1;
            PL = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Parallel Load 4'b1010", test_num);
            reset_dut();
            P = 4'b1010;
            PL = 1;
            @(posedge CLK);
            #1;
            PL = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right Shift (CTRL=1) SI=1", test_num);
            reset_dut();

            P = 4'b1000; PL = 1;
            @(posedge CLK); #1;
            PL = 0; CTRL = 1; SI = 1;
            @(posedge CLK); #1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right Shift (CTRL=1) SI=0", test_num);
            reset_dut();

            P = 4'b1000; PL = 1;
            @(posedge CLK); #1;
            PL = 0; CTRL = 1; SI = 0;
            @(posedge CLK); #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift (CTRL=0) SI=1", test_num);
            reset_dut();

            P = 4'b0001; PL = 1;
            @(posedge CLK); #1;
            PL = 0; CTRL = 0; SI = 1;
            @(posedge CLK); #1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift (CTRL=0) SI=0", test_num);
            reset_dut();

            P = 4'b0001; PL = 1;
            @(posedge CLK); #1;
            PL = 0; CTRL = 0; SI = 0;
            @(posedge CLK); #1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Right Shifts", test_num);
            reset_dut();
            CTRL = 1; SI = 1; PL = 0;
            repeat(4) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Left Shifts", test_num);
            reset_dut();
            CTRL = 0; SI = 1; PL = 0;
            repeat(4) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequence Load->Left->Right", test_num);
            reset_dut();

            P = 4'b0110; PL = 1;
            @(posedge CLK); #1;

            PL = 0; CTRL = 0; SI = 1;
            @(posedge CLK); #1;

            CTRL = 1; SI = 0;
            @(posedge CLK); #1;
            #1;

            check_outputs(4'b0110);
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
        input [3:0] expected_Q;
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
        $dumpvars(0,CLK, CTRL, P, PL, SI, Q);
    end

endmodule
