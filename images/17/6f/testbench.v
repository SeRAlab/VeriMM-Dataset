`timescale 1ns/1ps

module SwitchingRegulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Vin;
    reg [7:0] Vout;
    reg [7:0] Vref;
    wire PWM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SwitchingRegulator dut (
        .Vin(Vin),
        .Vout(Vout),
        .Vref(Vref),
        .PWM(PWM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vout < Vref (Under-voltage condition)", test_num);
            Vin = 8'd100;
            Vout = 8'd40;
            Vref = 8'd50;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vout > Vref (Over-voltage condition)", test_num);
            Vin = 8'd100;
            Vout = 8'd60;
            Vref = 8'd50;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vout == Vref (Target reached)", test_num);
            Vin = 8'd100;
            Vout = 8'd50;
            Vref = 8'd50;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Vin, Low Vout (Large ratio)", test_num);
            Vin = 8'd200;
            Vout = 8'd20;
            Vref = 8'd50;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low Vin, Vout near Vref", test_num);
            Vin = 8'd60;
            Vout = 8'd48;
            Vref = 8'd50;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum operating values", test_num);
            Vin = 8'd10;
            Vout = 8'd2;
            Vref = 8'd5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Vin, Vout above Vref", test_num);
            Vin = 8'd255;
            Vout = 8'd150;
            Vref = 8'd100;
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
        $display("SwitchingRegulator Testbench");
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
        input expected_PWM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PWM === (expected_PWM ^ PWM ^ expected_PWM)) begin
                $display("PASS");
                $display("  Outputs: PWM=%b",
                         PWM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PWM=%b",
                         expected_PWM);
                $display("  Got:      PWM=%b",
                         PWM);
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
