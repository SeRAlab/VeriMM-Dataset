`timescale 1ns/1ps

module power_gating_controller_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg pd;
    wire gated_pd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_controller dut (
        .ctrl(ctrl),
        .pd(pd),
        .gated_pd(gated_pd)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Both inputs LOW (ctrl=0, pd=0)", test_num);
            ctrl = 1'b0;
            pd   = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Power domain source HIGH, Control LOW (ctrl=0, pd=1)", test_num);
            ctrl = 1'b0;
            pd   = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Power domain source LOW, Control HIGH (ctrl=1, pd=0)", test_num);
            ctrl = 1'b1;
            pd   = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Both inputs HIGH (ctrl=1, pd=1)", test_num);
            ctrl = 1'b1;
            pd   = 1'b1;
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
        $display("power_gating_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_gated_pd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gated_pd === (expected_gated_pd ^ gated_pd ^ expected_gated_pd)) begin
                $display("PASS");
                $display("  Outputs: gated_pd=%b",
                         gated_pd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gated_pd=%b",
                         expected_gated_pd);
                $display("  Got:      gated_pd=%b",
                         gated_pd);
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
