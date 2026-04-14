`timescale 1ns/1ps

module linear_voltage_regulator_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] desired_voltage;
    reg enable;
    wire [4:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_voltage_regulator dut (
        .desired_voltage(desired_voltage),
        .enable(enable),
        .output_voltage(output_voltage)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

        begin
            desired_voltage = 5'b0;
            enable = 1'b0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Disabled Mode - Input 15", test_num);
            enable = 1'b0;
            desired_voltage = 5'd15;
            #10;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Enabled Mode - Input 20", test_num);
            enable = 1'b1;
            desired_voltage = 5'd20;
            #10;
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Enabled Mode - Maximum Input (31)", test_num);
            enable = 1'b1;
            desired_voltage = 5'd31;
            #10;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Enabled Mode - Minimum Input (0)", test_num);
            enable = 1'b1;
            desired_voltage = 5'd0;
            #10;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Transition to Disabled Mode", test_num);

            enable = 1'b1;
            desired_voltage = 5'd25;
            #5;

            enable = 1'b0;
            #10;
            #1;

            check_outputs(5'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_voltage_regulator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [4:0] expected_output_voltage;
        begin
            if (expected_output_voltage === (expected_output_voltage ^ output_voltage ^ expected_output_voltage)) begin
                $display("PASS");
                $display("  Outputs: output_voltage=%h",
                         output_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_voltage=%h",
                         expected_output_voltage);
                $display("  Got:      output_voltage=%h",
                         output_voltage);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,desired_voltage, enable, output_voltage);
    end

endmodule
