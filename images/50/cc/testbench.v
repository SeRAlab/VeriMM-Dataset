`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_IN;
    reg In1;
    reg enb;
    reg reset;
    wire Out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_IN(CLK_IN),
        .In1(In1),
        .enb(enb),
        .reset(reset),
        .Out1(Out1)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_IN = 0;
        forever #5 CLK_IN = ~CLK_IN;
    end

        task reset_dut;

        begin
            reset = 1;
            enb = 0;
            In1 = 0;
            @(posedge CLK_IN);
            #1;
            reset = 0;
            @(posedge CLK_IN);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Rising Edge Detection");
            reset_dut();
            enb = 1;
            In1 = 0;
            @(posedge CLK_IN);
            #1;
            In1 = 1;
            @(posedge CLK_IN);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Constant Low Input");
            reset_dut();
            enb = 1;
            In1 = 0;
            @(posedge CLK_IN);
            #1;
            In1 = 0;
            @(posedge CLK_IN);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Constant High Input");
            reset_dut();
            enb = 1;
            In1 = 1;
            @(posedge CLK_IN);
            #1;
            In1 = 1;
            @(posedge CLK_IN);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Falling Edge Input");
            reset_dut();
            enb = 1;
            In1 = 1;
            @(posedge CLK_IN);
            #1;
            In1 = 0;
            @(posedge CLK_IN);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Rising Edge While Disabled");
            reset_dut();
            enb = 0;
            In1 = 0;
            @(posedge CLK_IN);
            #1;
            In1 = 1;
            @(posedge CLK_IN);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enable Gating Check");
            reset_dut();

            enb = 1; In1 = 0; @(posedge CLK_IN); #1;

            enb = 0; In1 = 1; @(posedge CLK_IN); #1;

            enb = 1; In1 = 1; @(posedge CLK_IN); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiple Pulses");
            reset_dut();
            enb = 1;
            In1 = 0; @(posedge CLK_IN); #1;
            In1 = 1; @(posedge CLK_IN); #1;
            In1 = 0; @(posedge CLK_IN); #1;
            In1 = 1; @(posedge CLK_IN); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Reset Priority");
            reset_dut();
            enb = 1;
            In1 = 0; @(posedge CLK_IN); #1;
            reset = 1; In1 = 1; @(posedge CLK_IN); #1;
            #1;

            check_outputs(1'b0);
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
        input expected_Out1;
        begin
            if (expected_Out1 === (expected_Out1 ^ Out1 ^ expected_Out1)) begin
                $display("PASS");
                $display("  Outputs: Out1=%b",
                         Out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out1=%b",
                         expected_Out1);
                $display("  Got:      Out1=%b",
                         Out1);
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
        $dumpvars(0,CLK_IN, In1, enb, reset, Out1);
    end

endmodule
