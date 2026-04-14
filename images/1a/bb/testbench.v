`timescale 1ns/1ps

module switching_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Vin;
    reg [7:0] Vref;
    wire PWM_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator dut (
        .Vin(Vin),
        .Vref(Vref),
        .PWM_OUT(PWM_OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Vin > Vref (Large Difference)", test_num);
            Vin = 8'd200;
            Vref = 8'd50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Vin < Vref (Large Difference)", test_num);
            Vin = 8'd30;
            Vref = 8'd150;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Vin == Vref", test_num);
            Vin = 8'd100;
            Vref = 8'd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Vin is Max, Vref is Min", test_num);
            Vin = 8'd255;
            Vref = 8'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Vin is Min, Vref is Max", test_num);
            Vin = 8'd0;
            Vref = 8'd255;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Vin is Vref + 1", test_num);
            Vin = 8'd128;
            Vref = 8'd127;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Vin is Vref - 1", test_num);
            Vin = 8'd127;
            Vref = 8'd128;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Both zero", test_num);
            Vin = 8'd0;
            Vref = 8'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Both max", test_num);
            Vin = 8'd255;
            Vref = 8'd255;
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
        $display("switching_regulator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_PWM_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PWM_OUT === (expected_PWM_OUT ^ PWM_OUT ^ expected_PWM_OUT)) begin
                $display("PASS");
                $display("  Outputs: PWM_OUT=%b",
                         PWM_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PWM_OUT=%b",
                         expected_PWM_OUT);
                $display("  Got:      PWM_OUT=%b",
                         PWM_OUT);
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
