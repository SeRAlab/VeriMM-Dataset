`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Vin_n;
    reg Vin_p;
    wire Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Vin_n(Vin_n),
        .Vin_p(Vin_p),
        .Vout(Vout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial Reset (Below Lower Threshold)", test_num);
        Vin_p = 0; Vin_n = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Transition to High (Above Upper Threshold)", test_num);
        Vin_p = 0; Vin_n = 0;
        #10;
        Vin_p = 1; Vin_n = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Hysteresis (Staying High in Middle Range)", test_num);
        Vin_p = 0; Vin_n = 0;
        #10;
        Vin_p = 1; Vin_n = 1;
        #10;
        Vin_p = 0; Vin_n = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Transition from High to Low", test_num);
        Vin_p = 0; Vin_n = 0;
        #10;
        Vin_p = 1; Vin_n = 1;
        #10;
        Vin_p = 0; Vin_n = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Hysteresis (Staying Low in Middle Range)", test_num);
        Vin_p = 1; Vin_n = 1;
        #10;
        Vin_p = 0; Vin_n = 0;
        #10;
        Vin_p = 0; Vin_n = 1;
        #10;
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
        input expected_Vout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Vout === (expected_Vout ^ Vout ^ expected_Vout)) begin
                $display("PASS");
                $display("  Outputs: Vout=%b",
                         Vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vout=%b",
                         expected_Vout);
                $display("  Got:      Vout=%b",
                         Vout);
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
