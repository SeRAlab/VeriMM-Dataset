`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Vin;
    reg Vref;
    wire Iout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Vin(Vin),
        .Vref(Vref),
        .Iout(Iout)
    );
    task testcase001;

    begin
        $display("\nRunning testcase001: Vref=0, Vin=0");
        test_num = test_num + 1;
        Vref = 1'b0;
        Vin = 1'b0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Vref=1, Vin=0");
        test_num = test_num + 1;
        Vref = 1'b1;
        Vin = 1'b0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Vref=1, Vin=1");
        test_num = test_num + 1;
        Vref = 1'b1;
        Vin = 1'b1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Vref=0, Vin=1");
        test_num = test_num + 1;
        Vref = 1'b0;
        Vin = 1'b1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Transition Vref=1, Vin=0 -> Vin=1");
        test_num = test_num + 1;
        Vref = 1'b1;
        Vin = 1'b0;
        #5;
        Vin = 1'b1;
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
        input expected_Iout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Iout === (expected_Iout ^ Iout ^ expected_Iout)) begin
                $display("PASS");
                $display("  Outputs: Iout=%b",
                         Iout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Iout=%b",
                         expected_Iout);
                $display("  Got:      Iout=%b",
                         Iout);
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
