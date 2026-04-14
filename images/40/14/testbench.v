`timescale 1ns/1ps

module hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [31:0] current_inst;
    reg [31:0] prev_inst;
    wire hazard_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection dut (
        .control(control),
        .current_inst(current_inst),
        .prev_inst(prev_inst),
        .hazard_signal(hazard_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Data Hazard on RS (RAW)", test_num);
            control = 1;

            prev_inst = (5 << 11);

            current_inst = (5 << 21);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Data Hazard on RT (RAW)", test_num);
            control = 1;

            prev_inst = (10 << 11);

            current_inst = (10 << 16);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: No Hazard (Different Registers)", test_num);
            control = 1;

            prev_inst = (15 << 11);

            current_inst = (1 << 21) | (2 << 16);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Hazard condition present but control signal is Low", test_num);
            control = 0;

            prev_inst = (7 << 11);
            current_inst = (7 << 21);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: No Hazard on Register 0", test_num);
            control = 1;


            prev_inst = (0 << 11);
            current_inst = (0 << 21) | (0 << 16);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Simultaneous RS and RT match", test_num);
            control = 1;

            prev_inst = (8 << 11);

            current_inst = (8 << 21) | (8 << 16);
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
        $display("hazard_detection Testbench");
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
        input expected_hazard_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hazard_signal === (expected_hazard_signal ^ hazard_signal ^ expected_hazard_signal)) begin
                $display("PASS");
                $display("  Outputs: hazard_signal=%b",
                         hazard_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hazard_signal=%b",
                         expected_hazard_signal);
                $display("  Got:      hazard_signal=%b",
                         hazard_signal);
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
