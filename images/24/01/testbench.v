`timescale 1ns/1ps

module current_sensor_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] current_limit;
    reg [7:0] current_sense;
    wire alert;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_sensor_comparator dut (
        .current_limit(current_limit),
        .current_sense(current_sense),
        .alert(alert)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: current_sense < current_limit (Normal condition)", test_num);
        current_limit = 8'd100;
        current_sense = 8'd50;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: current_sense == current_limit (Boundary condition)", test_num);
        current_limit = 8'd100;
        current_sense = 8'd100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: current_sense > current_limit (Alert condition)", test_num);
        current_limit = 8'd100;
        current_sense = 8'd150;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Minimum values (0, 0)", test_num);
        current_limit = 8'd0;
        current_sense = 8'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum values (255, 255)", test_num);
        current_limit = 8'd255;
        current_sense = 8'd255;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sense 1 above limit", test_num);
        current_limit = 8'd127;
        current_sense = 8'd128;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sense 1 below limit", test_num);
        current_limit = 8'd128;
        current_sense = 8'd127;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Sense, Min Limit", test_num);
        current_limit = 8'd0;
        current_sense = 8'd255;
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
        $display("current_sensor_comparator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_alert;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alert === (expected_alert ^ alert ^ expected_alert)) begin
                $display("PASS");
                $display("  Outputs: alert=%b",
                         alert);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alert=%b",
                         expected_alert);
                $display("  Got:      alert=%b",
                         alert);
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
