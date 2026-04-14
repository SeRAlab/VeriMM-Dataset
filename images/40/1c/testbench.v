`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] estimated_state;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] corrected_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .estimated_state(estimated_state),
        .measurement(measurement),
        .reset(reset),
        .corrected_state(corrected_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        estimated_state = 0;
        measurement = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase %0d: Reset State", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase %0d: Measurement matches Estimate", test_num);
        estimated_state = 16'd1000;
        measurement = 16'd1000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd1000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase %0d: Positive Measurement Offset", test_num);
        estimated_state = 16'd100;
        measurement     = 16'd200;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd150);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase %0d: Negative Measurement Offset", test_num);
        estimated_state = 16'd500;
        measurement     = 16'd300;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd400);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase %0d: Large Value Fusion", test_num);
        estimated_state = 16'd40000;
        measurement     = 16'd20000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd30000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Testcase %0d: Small Variation Truncation", test_num);
        estimated_state = 16'd10;
        measurement     = 16'd11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kalman_filter Testbench");
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
        input [15:0] expected_corrected_state;
        begin
            if (expected_corrected_state === (expected_corrected_state ^ corrected_state ^ expected_corrected_state)) begin
                $display("PASS");
                $display("  Outputs: corrected_state=%h",
                         corrected_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: corrected_state=%h",
                         expected_corrected_state);
                $display("  Got:      corrected_state=%h",
                         corrected_state);
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
        $dumpvars(0,clk, estimated_state, measurement, reset, corrected_state);
    end

endmodule
