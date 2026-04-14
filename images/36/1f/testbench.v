`timescale 1ns/1ps

module VCO_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ctrl_voltage;
    wire [6:0] out_freq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VCO dut (
        .ctrl_voltage(ctrl_voltage),
        .out_freq(out_freq)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum Control Voltage", test_num);
            ctrl_voltage = 4'd0;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Low Control Voltage (1)", test_num);
            ctrl_voltage = 4'd1;
            #1;

            check_outputs(7'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-range Control Voltage (8)", test_num);
            ctrl_voltage = 4'd8;
            #1;

            check_outputs(7'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Control Voltage (12)", test_num);
            ctrl_voltage = 4'd12;
            #1;

            check_outputs(7'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Control Voltage (15)", test_num);
            ctrl_voltage = 4'd15;
            #1;

            check_outputs(7'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Monotonicity Step Check (4 to 5)", test_num);
            ctrl_voltage = 4'd4;
            #1;
            ctrl_voltage = 4'd5;
            #1;

            check_outputs(7'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VCO Testbench");
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
        input [6:0] expected_out_freq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_freq === (expected_out_freq ^ out_freq ^ expected_out_freq)) begin
                $display("PASS");
                $display("  Outputs: out_freq=%h",
                         out_freq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_freq=%h",
                         expected_out_freq);
                $display("  Got:      out_freq=%h",
                         out_freq);
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
