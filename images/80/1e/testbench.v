`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg btnA;
    reg btnB;
    reg btnC;
    wire dispenseBar;
    wire dispenseChips;
    wire dispenseSoda;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .btnA(btnA),
        .btnB(btnB),
        .btnC(btnC),
        .dispenseBar(dispenseBar),
        .dispenseChips(dispenseChips),
        .dispenseSoda(dispenseSoda)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: Dispense Bar", test_num);

        btnA = 0; btnB = 0; btnC = 0;
        #10;

        btnA = 1;
        #10;

        #1;


        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: Dispense Chips", test_num);

        btnA = 0; btnB = 0; btnC = 0;
        #10;

        btnB = 1;
        #10;

        #1;


        check_outputs(0, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: Dispense Soda", test_num);

        btnA = 0; btnB = 0; btnC = 0;
        #10;

        btnC = 1;
        #10;

        #1;


        check_outputs(0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: IDLE State (No Buttons)", test_num);

        btnA = 0; btnB = 0; btnC = 0;
        #10;

        #1;


        check_outputs(0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: Conflict Test (btnA and btnC)", test_num);

        btnA = 0; btnB = 0; btnC = 0;
        #10;

        btnA = 1; btnC = 1;
        #10;



        #1;




        check_outputs(1, 0, 0);
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
        input expected_dispenseBar;
        input expected_dispenseChips;
        input expected_dispenseSoda;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dispenseBar === (expected_dispenseBar ^ dispenseBar ^ expected_dispenseBar) &&
                expected_dispenseChips === (expected_dispenseChips ^ dispenseChips ^ expected_dispenseChips) &&
                expected_dispenseSoda === (expected_dispenseSoda ^ dispenseSoda ^ expected_dispenseSoda)) begin
                $display("PASS");
                $display("  Outputs: dispenseBar=%b, dispenseChips=%b, dispenseSoda=%b",
                         dispenseBar, dispenseChips, dispenseSoda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dispenseBar=%b, dispenseChips=%b, dispenseSoda=%b",
                         expected_dispenseBar, expected_dispenseChips, expected_dispenseSoda);
                $display("  Got:      dispenseBar=%b, dispenseChips=%b, dispenseSoda=%b",
                         dispenseBar, dispenseChips, dispenseSoda);
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
