`timescale 1ns/1ps

module switching_regulator_controller_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Vin;
    reg [7:0] Vref;
    wire Vout_control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator_controller dut (
        .Vin(Vin),
        .Vref(Vref),
        .Vout_control(Vout_control)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vin > Vref (Standard High)", test_num);
            Vin = 8'd150;
            Vref = 8'd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vin < Vref (Standard Low)", test_num);
            Vin = 8'd50;
            Vref = 8'd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vin == Vref (Boundary Low)", test_num);
            Vin = 8'd100;
            Vref = 8'd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Vin, Min Vref", test_num);
            Vin = 8'hFF;
            Vref = 8'h00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Min Vin, Max Vref", test_num);
            Vin = 8'h00;
            Vref = 8'hFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both Zero", test_num);
            Vin = 8'd0;
            Vref = 8'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vin just above Vref", test_num);
            Vin = 8'd129;
            Vref = 8'd128;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vin just below Vref", test_num);
            Vin = 8'd127;
            Vref = 8'd128;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both Max Value", test_num);
            Vin = 8'hFF;
            Vref = 8'hFF;
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
        $display("switching_regulator_controller Testbench");
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
        input expected_Vout_control;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Vout_control === (expected_Vout_control ^ Vout_control ^ expected_Vout_control)) begin
                $display("PASS");
                $display("  Outputs: Vout_control=%b",
                         Vout_control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vout_control=%b",
                         expected_Vout_control);
                $display("  Got:      Vout_control=%b",
                         Vout_control);
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
