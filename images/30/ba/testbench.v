`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] target;
    wire [3:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .reset(reset),
        .target(target),
        .output_signal(output_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        target = 4'b0000;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Target = 5", test_num);
        reset_dut();
        target = 4'd5;

        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Target = 15", test_num);
        reset_dut();
        target = 4'd15;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Target = 0", test_num);
        reset_dut();
        target = 4'd0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Target = 10", test_num);
        reset_dut();
        target = 4'd10;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Target = 3", test_num);
        reset_dut();
        target = 4'd3;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deadbeat_controller Testbench");
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
        input [3:0] expected_output_signal;
        begin
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
        $dumpvars(0,clk, reset, target, output_signal);
    end

endmodule
