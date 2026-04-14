`timescale 1ns/1ps

module KalmanFilter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] sensor1;
    reg [15:0] sensor2;
    wire [15:0] fused_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KalmanFilter dut (
        .clk(clk),
        .reset(reset),
        .sensor1(sensor1),
        .sensor2(sensor2),
        .fused_output(fused_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sensor1 = 16'h0;
            sensor2 = 16'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Inputs", test_num);
            reset_dut();
            sensor1 = 16'h0000;
            sensor2 = 16'h0000;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identical Inputs (S1=100, S2=100)", test_num);
            reset_dut();
            sensor1 = 16'd100;
            sensor2 = 16'd100;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Balanced Sensor Fusion (S1=200, S2=100)", test_num);
            reset_dut();
            sensor1 = 16'd200;
            sensor2 = 16'd100;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'd150);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Range Fusion", test_num);
            reset_dut();
            sensor1 = 16'hFFFF;
            sensor2 = 16'hFFFF;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dynamic Convergence", test_num);
            reset_dut();

            sensor1 = 16'd10;
            sensor2 = 16'd10;
            repeat(5) @(posedge clk);

            sensor1 = 16'd500;
            sensor2 = 16'd500;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd500);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KalmanFilter Testbench");
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
        input [15:0] expected_fused_output;
        begin
            if (expected_fused_output === (expected_fused_output ^ fused_output ^ expected_fused_output)) begin
                $display("PASS");
                $display("  Outputs: fused_output=%h",
                         fused_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fused_output=%h",
                         expected_fused_output);
                $display("  Got:      fused_output=%h",
                         fused_output);
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
        $dumpvars(0,clk, reset, sensor1, sensor2, fused_output);
    end

endmodule
