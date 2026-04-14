`timescale 1ns/1ps

module vco_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] control_voltage;
    reg enable;
    wire frequency_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vco dut (
        .clk(clk),
        .control_voltage(control_voltage),
        .enable(enable),
        .frequency_out(frequency_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        control_voltage = 4'b0000;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: VCO Disabled Check", test_num);
        reset_dut();

        enable = 0;
        control_voltage = 4'hF;
        repeat(20) @(posedge clk);


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Low Control Voltage (CV=1)", test_num);
        reset_dut();

        enable = 1;
        control_voltage = 4'h1;

        repeat(4) @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: High Control Voltage (CV=8)", test_num);
        reset_dut();

        enable = 1;
        control_voltage = 4'h8;

        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mid-Range Control Voltage Wrap-around (CV=4)", test_num);
        reset_dut();

        enable = 1;
        control_voltage = 4'h4;

        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Full Cycle Toggle Check", test_num);
        reset_dut();

        enable = 1;
        control_voltage = 4'h8;


        repeat(2) @(posedge clk);
        #1;
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
        $display("vco Testbench");
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
        input expected_frequency_out;
        begin
            if (expected_frequency_out === (expected_frequency_out ^ frequency_out ^ expected_frequency_out)) begin
                $display("PASS");
                $display("  Outputs: frequency_out=%b",
                         frequency_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_out=%b",
                         expected_frequency_out);
                $display("  Got:      frequency_out=%b",
                         frequency_out);
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
        $dumpvars(0,clk, control_voltage, enable, frequency_out);
    end

endmodule
