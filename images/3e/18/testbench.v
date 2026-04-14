`timescale 1ns/1ps

module current_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] current_input;
    wire [2:0] current_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_sensor dut (
        .current_input(current_input),
        .current_status(current_status)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Low Current Boundary (Min)", test_num);
            current_input = 5'd0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Low Current Boundary (Max)", test_num);
            current_input = 5'd7;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Medium Current Boundary (Min)", test_num);
            current_input = 5'd8;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Medium Current Boundary (Max)", test_num);
            current_input = 5'd15;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: High Current Boundary (Min)", test_num);
            current_input = 5'd16;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: High Current Boundary (Max)", test_num);
            current_input = 5'd31;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Low Current Mid-range", test_num);
            current_input = 5'd4;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Medium Current Mid-range", test_num);
            current_input = 5'd12;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: High Current Mid-range", test_num);
            current_input = 5'd24;
            #1;

            check_outputs(3'b010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("current_sensor Testbench");
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
        input [2:0] expected_current_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_current_status === (expected_current_status ^ current_status ^ expected_current_status)) begin
                $display("PASS");
                $display("  Outputs: current_status=%h",
                         current_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_status=%h",
                         expected_current_status);
                $display("  Got:      current_status=%h",
                         current_status);
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
