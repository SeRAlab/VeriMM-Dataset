`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg dev_in;
    wire dev_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .ctrl(ctrl),
        .dev_in(dev_in),
        .dev_out(dev_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power Gated (ctrl=0), Input Low", test_num);
            ctrl = 1'b0;
            dev_in = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power Gated (ctrl=0), Input High", test_num);
            ctrl = 1'b0;
            dev_in = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power Active (ctrl=1), Input Low", test_num);
            ctrl = 1'b1;
            dev_in = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power Active (ctrl=1), Input High", test_num);
            ctrl = 1'b1;
            dev_in = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition from Active to Gated", test_num);

            ctrl = 1'b1;
            dev_in = 1'b1;
            #5;

            ctrl = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition from Gated to Active", test_num);

            ctrl = 1'b0;
            dev_in = 1'b1;
            #5;

            ctrl = 1'b1;
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
        $display("power_gating Testbench");
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
        input expected_dev_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dev_out === (expected_dev_out ^ dev_out ^ expected_dev_out)) begin
                $display("PASS");
                $display("  Outputs: dev_out=%b",
                         dev_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dev_out=%b",
                         expected_dev_out);
                $display("  Got:      dev_out=%b",
                         dev_out);
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
