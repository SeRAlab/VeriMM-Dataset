`timescale 1ns/1ps

module bluetooth_status_checker_tb;

    // Testbench signals (combinational circuit)
    reg connection_status;
    reg enable;
    wire status_message;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_status_checker dut (
        .connection_status(connection_status),
        .enable(enable),
        .status_message(status_message)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: System disabled, Device disconnected", test_num);
            enable = 0;
            connection_status = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: System disabled, Device connected", test_num);
            enable = 0;
            connection_status = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: System enabled, Device disconnected", test_num);
            enable = 1;
            connection_status = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: System enabled, Device connected", test_num);
            enable = 1;
            connection_status = 1;
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_status_checker Testbench");
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
        input expected_status_message;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_status_message === (expected_status_message ^ status_message ^ expected_status_message)) begin
                $display("PASS");
                $display("  Outputs: status_message=%b",
                         status_message);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status_message=%b",
                         expected_status_message);
                $display("  Got:      status_message=%b",
                         status_message);
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
