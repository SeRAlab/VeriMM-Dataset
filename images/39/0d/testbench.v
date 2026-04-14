`timescale 1ns/1ps

module voltage_sensor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] voltage;
    wire alert;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_sensor dut (
        .clk(clk),
        .reset(reset),
        .voltage(voltage),
        .alert(alert)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        voltage = 0;
        #15;
        reset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Post-Reset Initialization", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Below Threshold (Voltage = 3)", test_num);
        reset_dut();
        voltage = 8'd3;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: At Threshold Boundary (Voltage = 5)", test_num);
        reset_dut();
        voltage = 8'd5;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Above Threshold (Voltage = 10)", test_num);
        reset_dut();
        voltage = 8'd10;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Asynchronous Reset Override", test_num);
        reset_dut();
        voltage = 8'd20;
        @(posedge clk);
        #2;
        reset = 1;
        #1;
        #1;

        check_outputs(1'b0);
        reset = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: High to Low Transition", test_num);
        reset_dut();
        voltage = 8'd15;
        @(posedge clk);
        #2;
        voltage = 8'd2;
        @(posedge clk);
        #2;
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
        $display("voltage_sensor Testbench");
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
        input expected_alert;
        begin
            if (expected_alert === (expected_alert ^ alert ^ expected_alert)) begin
                $display("PASS");
                $display("  Outputs: alert=%b",
                         alert);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alert=%b",
                         expected_alert);
                $display("  Got:      alert=%b",
                         alert);
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
        $dumpvars(0,clk, reset, voltage, alert);
    end

endmodule
