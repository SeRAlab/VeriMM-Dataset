`timescale 1ns/1ps

module power_gating_controller_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] current_state;
    reg power_enable;
    wire [2:0] power_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_controller dut (
        .current_state(current_state),
        .power_enable(power_enable),
        .power_state(power_state)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Enable High, Current State 7 (Fully Powered)", test_num);
            current_state = 3'b111;
            power_enable = 1'b1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Enable High, Current State 4 (Intermediate)", test_num);
            current_state = 3'b100;
            power_enable = 1'b1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Enable High, Current State 0 (Off)", test_num);
            current_state = 3'b000;
            power_enable = 1'b1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Enable Low, Current State 7 (Force Power Down)", test_num);
            current_state = 3'b111;
            power_enable = 1'b0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Enable Low, Current State 2 (Force Power Down)", test_num);
            current_state = 3'b010;
            power_enable = 1'b0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Enable Low, Current State 0 (Maintain Off)", test_num);
            current_state = 3'b000;
            power_enable = 1'b0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Enable High, Current State 5", test_num);
            current_state = 3'b101;
            power_enable = 1'b1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_gating_controller Testbench");
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
        input [2:0] expected_power_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_state === (expected_power_state ^ power_state ^ expected_power_state)) begin
                $display("PASS");
                $display("  Outputs: power_state=%h",
                         power_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_state=%h",
                         expected_power_state);
                $display("  Got:      power_state=%h",
                         power_state);
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
