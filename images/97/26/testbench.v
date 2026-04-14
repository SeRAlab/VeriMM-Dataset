`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg [3:0] D;
    reg LD;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLR(CLR),
        .D(D),
        .LD(LD),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLR = 1;
            LD = 0;
            D = 0;
            @(posedge CLK);
            #1;
            CLR = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            LD = 1;
            D = 4'hA;
            @(posedge CLK);
            #1;

            CLR = 1;
            LD = 0;
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Clear functionality", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            LD = 1;
            D = 4'h5;
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Load value 4'h5", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            LD = 1;
            D = 4'b0110;
            @(posedge CLK);
            #1;

            LD = 0;
            @(posedge CLK);
            #1;

            $display("Testcase %0d: Shift Right (MSB=0)", test_num);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            LD = 1;
            D = 4'b1000;
            @(posedge CLK);
            #1;

            LD = 0;
            @(posedge CLK);
            #1;

            $display("Testcase %0d: Shift Right (MSB=1, sign extension)", test_num);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            LD = 1;
            D = 4'b1011;
            @(posedge CLK);
            #1;
            LD = 0;
            @(posedge CLK);
            #1;
            @(posedge CLK);
            #1;
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Multiple shifts (3 times)", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            CLR = 1;
            LD = 1;
            D = 4'hF;
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Priority check (CLR vs LD)", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            LD = 1;
            D = 4'b0100;
            @(posedge CLK);
            #1;
            LD = 0;
            @(posedge CLK);
            @(posedge CLK);
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Shifting MSB=0 towards zero", test_num);
            #1;

            check_outputs(4'b0000);
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
        $dumpvars(0,CLK, CLR, D, LD, Q);
    end

endmodule
