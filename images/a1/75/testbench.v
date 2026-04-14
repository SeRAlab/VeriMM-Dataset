`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [3:0] DutyCycle;
    reg Reset;
    wire PWM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .DutyCycle(DutyCycle),
        .Reset(Reset),
        .PWM(PWM)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Reset = 1;
        DutyCycle = 0;
        @(posedge Clk);
        #1;
        Reset = 0;
        @(posedge Clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: PWM Initial High State", test_num);
        reset_dut();
        DutyCycle = 4'd8;
        @(posedge Clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: PWM Mid-High Phase Check", test_num);
        reset_dut();
        DutyCycle = 4'd10;
        repeat(5) @(posedge Clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: PWM Low Phase Check", test_num);
        reset_dut();
        DutyCycle = 4'd5;
        repeat(10) @(posedge Clk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Duty Cycle Check", test_num);
        reset_dut();
        DutyCycle = 4'd0;
        repeat(20) @(posedge Clk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Duty Cycle Window Check", test_num);
        reset_dut();
        DutyCycle = 4'd15;
        repeat(14) @(posedge Clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Counter Roll-over Check", test_num);
        reset_dut();
        DutyCycle = 4'd5;

        repeat(16000) @(posedge Clk);
        #2;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pre-rollover State Check", test_num);
        reset_dut();
        DutyCycle = 4'd12;
        repeat(15998) @(posedge Clk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-period DutyCycle Change", test_num);
        reset_dut();
        DutyCycle = 4'd15;
        repeat(5) @(posedge Clk);
        DutyCycle = 4'd2;
        repeat(2) @(posedge Clk);
        #1;

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
        input expected_PWM;
        begin
            if (expected_PWM === (expected_PWM ^ PWM ^ expected_PWM)) begin
                $display("PASS");
                $display("  Outputs: PWM=%b",
                         PWM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PWM=%b",
                         expected_PWM);
                $display("  Got:      PWM=%b",
                         PWM);
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
        $dumpvars(0,Clk, DutyCycle, Reset, PWM);
    end

endmodule
