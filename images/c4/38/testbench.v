`timescale 1ns/1ps

module const_voltage_driver_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    wire vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    const_voltage_driver dut (
        .ctrl(ctrl),
        .vout(vout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Driver Enabled - Expecting Constant Voltage Level", test_num);


            ctrl = 1'b1;


            #20;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Driver Disabled - Expecting Low Output", test_num);


            ctrl = 1'b0;


            #20;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition Disabled -> Enabled", test_num);

            ctrl = 1'b0;
            #10;
            ctrl = 1'b1;


            #20;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition Enabled -> Disabled", test_num);

            ctrl = 1'b1;
            #10;
            ctrl = 1'b0;


            #20;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rapid Toggle Stability (Final state Enabled)", test_num);

            ctrl = 1'b0; #5;
            ctrl = 1'b1; #5;
            ctrl = 1'b0; #5;
            ctrl = 1'b1;


            #20;


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
        $display("const_voltage_driver Testbench");
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
