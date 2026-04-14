`timescale 1ns/1ps

module LDO_tb;

    // Testbench signals (combinational circuit)
    reg Vctrl;
    reg Vin;
    wire Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO dut (
        .Vctrl(Vctrl),
        .Vin(Vin),
        .Vout(Vout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: LDO Disabled", test_num);
            Vctrl = 0;
            Vin = 5;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: LDO Enabled (Vin=5V)", test_num);
            Vctrl = 1;
            Vin = 5;
            #1;

            check_outputs(4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: LDO Enabled (Vin=1V)", test_num);
            Vctrl = 1;
            Vin = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: LDO Enabled (Vin=10V)", test_num);
            Vctrl = 1;
            Vin = 10;
            #1;

            check_outputs(9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Shutdown Transition", test_num);

            Vctrl = 1;
            Vin = 8;
            #2;

            Vctrl = 0;
            Vin = 8;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: High Voltage Test (Vin=15V)", test_num);
            Vctrl = 1;
            Vin = 15;
            #1;

            check_outputs(14);
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
