`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] EmitDelay;
    reg [5:0] Emit_Width;
    reg RX_Gate;
    reg Transmit_CLK;
    wire TXN;
    wire TXP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EmitDelay(EmitDelay),
        .Emit_Width(Emit_Width),
        .RX_Gate(RX_Gate),
        .Transmit_CLK(Transmit_CLK),
        .TXN(TXN),
        .TXP(TXP)
    );

    // Clock generation (10ns period)
    initial begin
        RX_Gate = 0;
        forever #5 RX_Gate = ~RX_Gate;
    end

        task reset_dut;

        begin
            EmitDelay = 0;
            Emit_Width = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Short Delay/Width - Check Idle After Completion", test_num);
            reset_dut();
            EmitDelay = 8'd5;
            Emit_Width = 6'd5;
            #500;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Medium Delay - Check Pulse Active State", test_num);
            reset_dut();
            EmitDelay = 8'd10;
            Emit_Width = 6'd20;


            #200;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Long Width - Check Pulse Active State", test_num);
            reset_dut();
            EmitDelay = 8'd2;
            Emit_Width = 6'd50;
            #150;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Long Delay - Check Idle State Before Pulse", test_num);
            reset_dut();
            EmitDelay = 8'd50;
            Emit_Width = 6'd10;
            #100;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max Delay/Width - Check Idle After Completion", test_num);
            reset_dut();
            EmitDelay = 8'd255;
            Emit_Width = 6'd63;

            #4000;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_TXN;
        input expected_TXP;
        begin
            if (expected_TXN === (expected_TXN ^ TXN ^ expected_TXN) &&
                expected_TXP === (expected_TXP ^ TXP ^ expected_TXP)) begin
                $display("PASS");
                $display("  Outputs: TXN=%b, TXP=%b",
                         TXN, TXP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TXN=%b, TXP=%b",
                         expected_TXN, expected_TXP);
                $display("  Got:      TXN=%b, TXP=%b",
                         TXN, TXP);
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
        $dumpvars(0,EmitDelay, Emit_Width, RX_Gate, Transmit_CLK, TXN, TXP);
    end

endmodule
