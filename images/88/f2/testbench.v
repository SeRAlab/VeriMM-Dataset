`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Btn1;
    reg Btn2;
    reg Btn3;
    reg Btn4;
    reg Reset;
    reg Test;
    reg setVal;
    wire [2:0] L1;
    wire [2:0] L2;
    wire [2:0] L3;
    wire [2:0] L4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Btn1(Btn1),
        .Btn2(Btn2),
        .Btn3(Btn3),
        .Btn4(Btn4),
        .Reset(Reset),
        .Test(Test),
        .setVal(setVal),
        .L1(L1),
        .L2(L2),
        .L3(L3),
        .L4(L4)
    );

    // Clock generation (10ns period)
    initial begin
        Btn1 = 0;
        forever #5 Btn1 = ~Btn1;
    end

        task reset_dut;

        begin
            Reset = 1;
            Btn2 = 0;
            Btn3 = 0;
            Btn4 = 0;
            setVal = 0;
            Test = 0;
            #12;
            Reset = 0;
            #8;
        end
        endtask
    task pulse_btn2;

        begin
            Btn2 = 1; #10; Btn2 = 0; #10;
        end
        endtask

    task pulse_btn3;

        begin
            Btn3 = 1; #10; Btn3 = 0; #10;
        end
        endtask

    task pulse_btn4;

        begin
            Btn4 = 1; #10; Btn4 = 0; #10;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset and Basic State", test_num);
            reset_dut();


            #10;
            #1;

            check_outputs(3'd1, 3'd0, 3'd0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Independent Increments", test_num);
            reset_dut();

            pulse_btn2();
            pulse_btn3();
            pulse_btn3();
            pulse_btn4();



            if (L2 === 3'd1 && L3 === 3'd2 && L4 === 3'd1) begin
                pass_count = pass_count + 1;
                $display("PASS: Manual counters L2-L4 independent.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: L2=%d, L3=%d, L4=%d", L2, L3, L4);
            end
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Wrap Around Verification", test_num);
            reset_dut();

            for(i=0; i<8; i=i+1) begin
                pulse_btn2();
            end

            #1;


            check_outputs(L1, 3'd0, 3'd0, 3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: setVal Operation", test_num);
            reset_dut();
            pulse_btn2();
            pulse_btn2();
            setVal = 1; #10; setVal = 0; #10;

            pulse_btn2();
            if (L2 === 3'd3) begin
                pass_count = pass_count + 1;
                $display("PASS: Counters continue after setVal.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: L2 expected 3, got %d", L2);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Counting", test_num);
            reset_dut();
            pulse_btn2();
            pulse_btn3();
            pulse_btn4();
            #10;
            reset_dut();
            #5;

            if (L2 === 3'd0 && L3 === 3'd0 && L4 === 3'd0) begin
                pass_count = pass_count + 1;
                $display("PASS: Mid-counting reset successful.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Counters not zero after reset.");
            end
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
        input [2:0] expected_L1;
        input [2:0] expected_L2;
        input [2:0] expected_L3;
        input [2:0] expected_L4;
        begin
            if (expected_L1 === (expected_L1 ^ L1 ^ expected_L1) &&
                expected_L2 === (expected_L2 ^ L2 ^ expected_L2) &&
                expected_L3 === (expected_L3 ^ L3 ^ expected_L3) &&
                expected_L4 === (expected_L4 ^ L4 ^ expected_L4)) begin
                $display("PASS");
                $display("  Outputs: L1=%h, L2=%h, L3=%h, L4=%h",
                         L1, L2, L3, L4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L1=%h, L2=%h, L3=%h, L4=%h",
                         expected_L1, expected_L2, expected_L3, expected_L4);
                $display("  Got:      L1=%h, L2=%h, L3=%h, L4=%h",
                         L1, L2, L3, L4);
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
        $dumpvars(0,Btn1, Btn2, Btn3, Btn4, Reset, Test, setVal, L1, L2, L3, L4);
    end

endmodule
