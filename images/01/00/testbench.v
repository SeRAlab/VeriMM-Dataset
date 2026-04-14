`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] division_ratio;
    reg [15:0] input_freq;
    reg reset;
    wire [15:0] control_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk(clk),
        .division_ratio(division_ratio),
        .input_freq(input_freq),
        .reset(reset),
        .control_voltage(control_voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_freq = 0;
            division_ratio = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Integer Division (Fin=100, Ratio=2.0)", test_num);
            reset_dut();
            input_freq = 16'd100;
            division_ratio = 16'h0200;
            #2000;

            #1;


            check_outputs(16'd200);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fractional Division (Fin=200, Ratio=1.5)", test_num);
            reset_dut();
            input_freq = 16'd200;
            division_ratio = 16'h0180;
            #2000;

            #1;


            check_outputs(16'd300);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Integer Division (Fin=50, Ratio=10.0)", test_num);
            reset_dut();
            input_freq = 16'd50;
            division_ratio = 16'h0A00;
            #2000;

            #1;


            check_outputs(16'd500);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex Fractional Division (Fin=80, Ratio=3.25)", test_num);
            reset_dut();
            input_freq = 16'd80;
            division_ratio = 16'h0340;
            #2000;

            #1;


            check_outputs(16'd260);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Freq Input (Fin=1000, Ratio=1.125)", test_num);
            reset_dut();
            input_freq = 16'd1000;
            division_ratio = 16'h0120;
            #2000;

            #1;


            check_outputs(16'd1125);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fractional_n_pll Testbench");
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
        input [15:0] expected_control_voltage;
        begin
            if (expected_control_voltage === (expected_control_voltage ^ control_voltage ^ expected_control_voltage)) begin
                $display("PASS");
                $display("  Outputs: control_voltage=%h",
                         control_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_voltage=%h",
                         expected_control_voltage);
                $display("  Got:      control_voltage=%h",
                         control_voltage);
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
        $dumpvars(0,clk, division_ratio, input_freq, reset, control_voltage);
    end

endmodule
