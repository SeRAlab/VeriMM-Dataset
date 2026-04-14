`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] RAM_DATA;
    reg SEL;
    reg TRIGGERED;
    wire [15:0] DATA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RAM_DATA(RAM_DATA),
        .SEL(SEL),
        .TRIGGERED(TRIGGERED),
        .DATA(DATA)
    );
    task testcase001;

    begin
        test_num = 1;
        SEL = 0;
        TRIGGERED = 0;
        RAM_DATA = 16'hAAAA;
        $display("Testcase %0d: SEL=0, TRIGGERED=0", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        SEL = 0;
        TRIGGERED = 1;
        RAM_DATA = 16'h5555;
        $display("Testcase %0d: SEL=0, TRIGGERED=1", test_num);
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        SEL = 1;
        TRIGGERED = 0;
        RAM_DATA = 16'hFFFF;
        $display("Testcase %0d: SEL=1, RAM_DATA=FFFF", test_num);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        SEL = 1;
        TRIGGERED = 1;
        RAM_DATA = 16'h1234;
        $display("Testcase %0d: SEL=1, RAM_DATA=1234", test_num);
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        RAM_DATA = 16'hBEEF;
        TRIGGERED = 1;
        SEL = 1;
        #5;

        SEL = 0;
        $display("Testcase %0d: Transition SEL 1 -> 0, TRIGGERED=1", test_num);
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        RAM_DATA = 16'hCAFE;
        TRIGGERED = 0;
        SEL = 0;
        #5;

        SEL = 1;
        $display("Testcase %0d: Transition SEL 0 -> 1, RAM_DATA=CAFE", test_num);
        #1;

        check_outputs(16'hCAFE);
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
        input [15:0] expected_DATA;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DATA === (expected_DATA ^ DATA ^ expected_DATA)) begin
                $display("PASS");
                $display("  Outputs: DATA=%h",
                         DATA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA=%h",
                         expected_DATA);
                $display("  Got:      DATA=%h",
                         DATA);
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

endmodule
