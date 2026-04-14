`timescale 1ns/1ps

module tcp_segment_checker_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] segment_length;
    wire is_full_segment;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segment_checker dut (
        .segment_length(segment_length),
        .is_full_segment(is_full_segment)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Minimum value (0)", test_num);
            segment_length = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Boundary below full (15)", test_num);
            segment_length = 5'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Full segment (16)", test_num);
            segment_length = 5'd16;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Boundary above full (17)", test_num);
            segment_length = 5'd17;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Maximum 5-bit value (31)", test_num);
            segment_length = 5'd31;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Typical partial segment (8)", test_num);
            segment_length = 5'd8;
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
        $display("tcp_segment_checker Testbench");
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
        input expected_is_full_segment;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_full_segment === (expected_is_full_segment ^ is_full_segment ^ expected_is_full_segment)) begin
                $display("PASS");
                $display("  Outputs: is_full_segment=%b",
                         is_full_segment);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_full_segment=%b",
                         expected_is_full_segment);
                $display("  Got:      is_full_segment=%b",
                         is_full_segment);
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
