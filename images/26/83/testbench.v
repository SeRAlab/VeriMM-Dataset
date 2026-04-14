`timescale 1ns/1ps

module temp_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] temp;
    wire overheat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_sensor dut (
        .temp(temp),
        .overheat(overheat)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Temperature = 0 (Min)", test_num);
            temp = 5'b00000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Temperature = 10", test_num);
            temp = 5'b01010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Temperature = 20 (Threshold Boundary)", test_num);
            temp = 5'b10100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Temperature = 21 (Above Threshold)", test_num);
            temp = 5'b10101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Temperature = 31 (Max)", test_num);
            temp = 5'b11111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Temperature = 25", test_num);
            temp = 5'd25;
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
        $display("temp_sensor Testbench");
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
        input expected_overheat;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overheat === (expected_overheat ^ overheat ^ expected_overheat)) begin
                $display("PASS");
                $display("  Outputs: overheat=%b",
                         overheat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overheat=%b",
                         expected_overheat);
                $display("  Got:      overheat=%b",
                         overheat);
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
