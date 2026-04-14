`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] load_signal;
    wire [1:0] frequency_setting;
    wire [1:0] voltage_setting;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .load_signal(load_signal),
        .frequency_setting(frequency_setting),
        .voltage_setting(voltage_setting)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load_signal = 3'b000;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Minimum load...");
            reset_dut();
            test_num = 1;
            load_signal = 3'b000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Low-mid load...");
            reset_dut();
            test_num = 2;
            load_signal = 3'b010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Mid-high load...");
            reset_dut();
            test_num = 3;
            load_signal = 3'b100;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Maximum load...");
            reset_dut();
            test_num = 4;
            load_signal = 3'b111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary load (1)...");
            reset_dut();
            test_num = 5;
            load_signal = 3'b001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Boundary load (6)...");
            reset_dut();
            test_num = 6;
            load_signal = 3'b110;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11, 2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
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
        input [1:0] expected_frequency_setting;
        input [1:0] expected_voltage_setting;
        begin
            if (expected_frequency_setting === (expected_frequency_setting ^ frequency_setting ^ expected_frequency_setting) &&
                expected_voltage_setting === (expected_voltage_setting ^ voltage_setting ^ expected_voltage_setting)) begin
                $display("PASS");
                $display("  Outputs: frequency_setting=%h, voltage_setting=%h",
                         frequency_setting, voltage_setting);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_setting=%h, voltage_setting=%h",
                         expected_frequency_setting, expected_voltage_setting);
                $display("  Got:      frequency_setting=%h, voltage_setting=%h",
                         frequency_setting, voltage_setting);
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
        $dumpvars(0,clk, load_signal, frequency_setting, voltage_setting);
    end

endmodule
