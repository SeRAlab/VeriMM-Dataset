`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Hysteresis;
    reg Vin;
    reg Vref_high;
    reg Vref_low;
    wire Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Hysteresis(Hysteresis),
        .Vin(Vin),
        .Vref_high(Vref_high),
        .Vref_low(Vref_low),
        .Vout(Vout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Transition from Low to High (Set)", test_num);

        Vin = 0; Vref_low = 1; Vref_high = 1; Hysteresis = 0;
        #10;


        Vin = 1; Vref_high = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Transition from High to Low (Reset)", test_num);

        Vin = 1; Vref_high = 0; Vref_low = 0; Hysteresis = 0;
        #10;


        Vin = 0; Vref_low = 1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hysteresis Effect - Hold High in Dead Zone", test_num);

        Vin = 1; Vref_high = 0; Vref_low = 0; Hysteresis = 0;
        #10;



        Vin = 0; Vref_low = 0; Vref_high = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hysteresis Effect - Hold Low in Dead Zone", test_num);

        Vin = 0; Vref_low = 1; Vref_high = 1; Hysteresis = 0;
        #10;



        Vin = 1; Vref_high = 1; Vref_low = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: High Input with Hysteresis Adjustment (Threshold Not Cleared)", test_num);

        Vin = 0; Vref_low = 1; Vref_high = 1; Hysteresis = 0;
        #10;




        Vin = 1; Vref_high = 1; Hysteresis = 1; Vref_low = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Low Input with Hysteresis Adjustment (Threshold Not Cleared)", test_num);

        Vin = 1; Vref_high = 0; Vref_low = 0; Hysteresis = 0;
        #10;




        Vin = 0; Vref_low = 0; Hysteresis = 1; Vref_high = 1;
        #10;
        #1;

        check_outputs(1'b1);
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
