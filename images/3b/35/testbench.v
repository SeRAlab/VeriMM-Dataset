`timescale 1ns/1ps

module LDO_Regulator_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg vin;
    wire vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Regulator dut (
        .control(control),
        .vin(vin),
        .vout(vout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Input Power, Control Low", test_num);
            vin = 1'b0;
            control = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vin=5V (Logic 1), Control Low", test_num);
            vin = 1'b1;
            control = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vin=5V (Logic 1), Control High", test_num);
            vin = 1'b1;
            control = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Regulation Shutdown (Control 1 -> 0)", test_num);
            vin = 1'b1;
            control = 1'b1;
            #5;
            control = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Loss during Regulation (Vin 1 -> 0)", test_num);
            vin = 1'b1;
            control = 1'b1;
            #5;
            vin = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control High, No Vin", test_num);
            vin = 1'b0;
            control = 1'b1;
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
        $display("LDO_Regulator Testbench");
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
        input expected_vout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vout === (expected_vout ^ vout ^ expected_vout)) begin
                $display("PASS");
                $display("  Outputs: vout=%b",
                         vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vout=%b",
                         expected_vout);
                $display("  Got:      vout=%b",
                         vout);
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
