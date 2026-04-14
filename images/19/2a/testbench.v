`timescale 1ns/1ps

module LDO_Controller_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Vin;
    reg [7:0] Vref;
    wire En;
    wire PWM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Controller dut (
        .Vin(Vin),
        .Vref(Vref),
        .En(En),
        .PWM(PWM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Vin < Vref", test_num);
            Vin = 8'd50;
            Vref = 8'd100;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Vin == Vref", test_num);
            Vin = 8'd128;
            Vref = 8'd128;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Vin > Vref (Small difference)", test_num);
            Vin = 8'd130;
            Vref = 8'd120;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Vin, Minimum Vref", test_num);
            Vin = 8'hFF;
            Vref = 8'h00;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum Vin, Maximum Vref", test_num);
            Vin = 8'h00;
            Vref = 8'hFF;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-range Vin > Vref", test_num);
            Vin = 8'd200;
            Vref = 8'd100;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Controller Testbench");
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
        input expected_En;
        input expected_PWM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_En === (expected_En ^ En ^ expected_En) &&
                expected_PWM === (expected_PWM ^ PWM ^ expected_PWM)) begin
                $display("PASS");
                $display("  Outputs: En=%b, PWM=%b",
                         En, PWM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: En=%b, PWM=%b",
                         expected_En, expected_PWM);
                $display("  Got:      En=%b, PWM=%b",
                         En, PWM);
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
