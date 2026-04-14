`timescale 1ns/1ps

module VCO_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] voltage_input;
    wire [7:0] frequency_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VCO dut (
        .clk(clk),
        .reset(reset),
        .voltage_input(voltage_input),
        .frequency_output(frequency_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            voltage_input = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Voltage Input (0)", test_num);
            reset_dut();
            voltage_input = 4'd0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Base Step Voltage Input (1)", test_num);
            reset_dut();
            voltage_input = 4'd1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range Voltage Input (8)", test_num);
            reset_dut();
            voltage_input = 4'd8;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Voltage Input (15)", test_num);
            reset_dut();
            voltage_input = 4'd15;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic Input Change (5 then 10)", test_num);
            reset_dut();


            voltage_input = 4'd5;
            repeat(2) @(posedge clk);


            voltage_input = 4'd10;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Override with Active Input", test_num);
            reset_dut();

            voltage_input = 4'd12;
            repeat(2) @(posedge clk);

            reset = 1;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_frequency_output;
        begin
            if (expected_frequency_output === (expected_frequency_output ^ frequency_output ^ expected_frequency_output)) begin
                $display("PASS");
                $display("  Outputs: frequency_output=%h",
                         frequency_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_output=%h",
                         expected_frequency_output);
                $display("  Got:      frequency_output=%h",
                         frequency_output);
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
        $dumpvars(0,clk, reset, voltage_input, frequency_output);
    end

endmodule
