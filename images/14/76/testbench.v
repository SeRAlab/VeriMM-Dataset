`timescale 1ns/1ps

module vco_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] control_voltage;
    wire [3:0] vco_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vco dut (
        .clk(clk),
        .control_voltage(control_voltage),
        .vco_output(vco_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control_voltage = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        reg [3:0] start_val;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Lowest Frequency (CV=00)", test_num);
            reset_dut();
            start_val = vco_output;
            control_voltage = 2'b00;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(start_val + 4'd5);
        end
        endtask

    task testcase002;

        reg [3:0] start_val;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Medium-Low Frequency (CV=01)", test_num);
            reset_dut();
            start_val = vco_output;
            control_voltage = 2'b01;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(start_val + 4'd8);
        end
        endtask

    task testcase003;

        reg [3:0] start_val;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Medium-High Frequency (CV=10)", test_num);
            reset_dut();
            start_val = vco_output;
            control_voltage = 2'b10;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(start_val + 4'd9);
        end
        endtask

    task testcase004;

        reg [3:0] start_val;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Highest Frequency (CV=11)", test_num);
            reset_dut();
            start_val = vco_output;
            control_voltage = 2'b11;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(start_val + 4'd0);
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
        input [3:0] expected_vco_output;
        begin
            if (expected_vco_output === (expected_vco_output ^ vco_output ^ expected_vco_output)) begin
                $display("PASS");
                $display("  Outputs: vco_output=%h",
                         vco_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vco_output=%h",
                         expected_vco_output);
                $display("  Got:      vco_output=%h",
                         vco_output);
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
        $dumpvars(0,clk, control_voltage, vco_output);
    end

endmodule
