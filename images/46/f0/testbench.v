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
        Transmit_CLK = 0;
        forever #5 Transmit_CLK = ~Transmit_CLK;
    end

        task reset_dut;

        begin
            RX_Gate = 1'b0;
            EmitDelay = 8'h00;
            Emit_Width = 6'h00;
            repeat(2) @(posedge Transmit_CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Normal operation (Delay=5, Width=10)", test_num);
            reset_dut();


            EmitDelay = 8'h85;
            Emit_Width = 6'd10;
            RX_Gate = 1'b1;


            repeat(20) @(posedge Transmit_CLK);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: RX_Gate disabled", test_num);
            reset_dut();

            EmitDelay = 8'h85;
            Emit_Width = 6'd10;
            RX_Gate = 1'b0;

            repeat(20) @(posedge Transmit_CLK);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: EmitDelay[7] (Internal Enable) disabled", test_num);
            reset_dut();

            EmitDelay = 8'h05;
            Emit_Width = 6'd10;
            RX_Gate = 1'b1;

            repeat(20) @(posedge Transmit_CLK);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Zero Delay pulse", test_num);
            reset_dut();

            EmitDelay = 8'h80;
            Emit_Width = 6'd5;
            RX_Gate = 1'b1;

            repeat(10) @(posedge Transmit_CLK);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Large Delay and Max Width", test_num);
            reset_dut();

            EmitDelay = 8'hFF;
            Emit_Width = 6'd63;
            RX_Gate = 1'b1;


            repeat(200) @(posedge Transmit_CLK);

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
