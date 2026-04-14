`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] input_voltage;
    wire [4:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .clk(clk),
        .input_voltage(input_voltage),
        .output_voltage(output_voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input_voltage = 5'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Input = 0");
            reset_dut();
            input_voltage = 5'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Input = 5");
            reset_dut();
            input_voltage = 5'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Input = 10");
            reset_dut();
            input_voltage = 5'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Input = 11 (Clamping)");
            reset_dut();
            input_voltage = 5'd11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Input = 31 (Max Clamping)");
            reset_dut();
            input_voltage = 5'd31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Persistence Check");
            reset_dut();
            input_voltage = 5'd7;
            @(posedge clk);
            #1;

            input_voltage = 5'd2;
            #2;
            #1;

            check_outputs(5'd21);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_regulator Testbench");
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
        $dumpvars(0,clk, input_voltage, output_voltage);
    end

endmodule
