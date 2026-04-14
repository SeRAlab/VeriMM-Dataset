`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] voltage_level;
    reg [7:0] workload;
    wire [1:0] action;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .voltage_level(voltage_level),
        .workload(workload),
        .action(action)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High Workload (200/255 > 70%%)", test_num);
        workload = 8'd200;
        voltage_level = 3'd3;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Low Workload (50/255 < 30%%)", test_num);
        workload = 8'd50;
        voltage_level = 3'd5;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Moderate Workload (128/255 ~ 50%%)", test_num);
        workload = 8'd128;
        voltage_level = 3'd4;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary High Workload (180/255)", test_num);
        workload = 8'd180;
        voltage_level = 3'd2;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary Low Workload (70/255)", test_num);
        workload = 8'd70;
        voltage_level = 3'd6;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Workload", test_num);
        workload = 8'd255;
        voltage_level = 3'd7;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Idle Workload", test_num);
        workload = 8'd0;
        voltage_level = 3'd0;
        #1;

        check_outputs(2'b11);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
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
        input [1:0] expected_action;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_action === (expected_action ^ action ^ expected_action)) begin
                $display("PASS");
                $display("  Outputs: action=%h",
                         action);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: action=%h",
                         expected_action);
                $display("  Got:      action=%h",
                         action);
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
