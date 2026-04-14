`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg diffOk;
    reg fiveMinTillArriv;
    reg poundOccu;
    reg reset;
    reg whatGate;
    wire doorOpen;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .diffOk(diffOk),
        .fiveMinTillArriv(fiveMinTillArriv),
        .poundOccu(poundOccu),
        .reset(reset),
        .whatGate(whatGate),
        .doorOpen(doorOpen)
    );
    task testcase001;

    begin
        test_num = 1;
        reset = 1; #5; reset = 0;
        ctrl = 0;
        diffOk = 1;
        whatGate = 0;
        poundOccu = 0;
        fiveMinTillArriv = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset = 1; #5; reset = 0;
        ctrl = 1;
        diffOk = 1;
        whatGate = 0;
        poundOccu = 0;
        fiveMinTillArriv = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset = 1; #5; reset = 0;
        ctrl = 1;
        diffOk = 0;
        whatGate = 0;
        poundOccu = 0;
        fiveMinTillArriv = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset = 1; #5; reset = 0;
        ctrl = 1;
        diffOk = 1;
        whatGate = 1;
        poundOccu = 0;
        fiveMinTillArriv = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset = 1; #5; reset = 0;
        ctrl = 1;
        diffOk = 1;
        whatGate = 1;
        poundOccu = 1;
        fiveMinTillArriv = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset = 1; #5; reset = 0;
        ctrl = 1;
        diffOk = 1;
        whatGate = 1;
        poundOccu = 0;
        fiveMinTillArriv = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset = 1; #5; reset = 0;
        ctrl = 1;
        diffOk = 0;
        whatGate = 1;
        poundOccu = 0;
        fiveMinTillArriv = 1;
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
        input expected_doorOpen;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_doorOpen === (expected_doorOpen ^ doorOpen ^ expected_doorOpen)) begin
                $display("PASS");
                $display("  Outputs: doorOpen=%b",
                         doorOpen);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: doorOpen=%b",
                         expected_doorOpen);
                $display("  Got:      doorOpen=%b",
                         doorOpen);
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
