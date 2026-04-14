`timescale 1ns/1ps

module LDO_tb;

    // Testbench signals (combinational circuit)
    reg Vdrop;
    reg Vin;
    reg Vref;
    reg enable;
    wire Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO dut (
        .Vdrop(Vdrop),
        .Vin(Vin),
        .Vref(Vref),
        .enable(enable),
        .Vout(Vout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: LDO Disabled Check", test_num);
            enable = 0;
            Vin    = 1'b1;
            Vdrop  = 1'b0;
            Vref   = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Normal Operation (Vref=1)", test_num);
            enable = 1;
            Vin    = 1'b1;
            Vdrop  = 1'b0;
            Vref   = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Normal Operation (Vref=0)", test_num);
            enable = 1;
            Vin    = 1'b1;
            Vdrop  = 1'b0;
            Vref   = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dropout Condition (Vin == Vdrop)", test_num);
            enable = 1;
            Vin    = 1'b1;
            Vdrop  = 1'b1;
            Vref   = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No Supply Voltage (Vin=0)", test_num);
            enable = 1;
            Vin    = 1'b0;
            Vdrop  = 1'b0;
            Vref   = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Under-voltage and Dropout", test_num);
            enable = 1;
            Vin    = 1'b0;
            Vdrop  = 1'b1;
            Vref   = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Toggle Enable Shutdown", test_num);
            enable = 1; Vin = 1; Vdrop = 0; Vref = 1;
            #5;
            enable = 0;
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
        $display("LDO Testbench");
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
