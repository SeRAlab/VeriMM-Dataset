`timescale 1ns/1ps

module ethernet_frame_checker_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] frame_length;
    wire is_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_frame_checker dut (
        .frame_length(frame_length),
        .is_valid(is_valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum valid length (64)", test_num);
            frame_length = 12'd64;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum valid length (1518)", test_num);
            frame_length = 12'd1518;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid length - below min (63)", test_num);
            frame_length = 12'd63;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid length - above max (1519)", test_num);
            frame_length = 12'd1519;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid length - zero (0)", test_num);
            frame_length = 12'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid length - max 12-bit (4095)", test_num);
            frame_length = 12'd4095;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Interior valid length (1000)", test_num);
            frame_length = 12'd1000;
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
        $display("ethernet_frame_checker Testbench");
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
        input expected_is_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_valid === (expected_is_valid ^ is_valid ^ expected_is_valid)) begin
                $display("PASS");
                $display("  Outputs: is_valid=%b",
                         is_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_valid=%b",
                         expected_is_valid);
                $display("  Got:      is_valid=%b",
                         is_valid);
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
