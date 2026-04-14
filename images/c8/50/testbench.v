`timescale 1ns/1ps

module XOR_GATE_tb;

    // Testbench signals (combinational circuit)
    reg IN1;
    wire OUT1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    XOR_GATE dut (
        .IN1(IN1),
        .OUT1(OUT1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Input IN1 = 0", test_num);
            IN1 = 1'b0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Input IN1 = 1", test_num);
            IN1 = 1'b1;

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
        $display("XOR_GATE Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        
        
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
        input expected_OUT1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT1 === (expected_OUT1 ^ OUT1 ^ expected_OUT1)) begin
                $display("PASS");
                $display("  Outputs: OUT1=%b",
                         OUT1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT1=%b",
                         expected_OUT1);
                $display("  Got:      OUT1=%b",
                         OUT1);
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
