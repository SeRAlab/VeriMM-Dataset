`timescale 1ns/1ps

module pitch_detection_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] signal_input;
    reg [7:0] threshold;
    wire pitch_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detection dut (
        .clk(clk),
        .rst(rst),
        .signal_input(signal_input),
        .threshold(threshold),
        .pitch_detected(pitch_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            signal_input = 8'd0;
            threshold = 8'd0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Signal > Threshold", test_num);
            reset_dut();
            signal_input = 8'd150;
            threshold    = 8'd100;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Signal < Threshold", test_num);
            reset_dut();
            signal_input = 8'd50;
            threshold    = 8'd100;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Signal == Threshold", test_num);
            reset_dut();
            signal_input = 8'd100;
            threshold    = 8'd100;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Max Signal vs High Threshold", test_num);
            reset_dut();
            signal_input = 8'hFF;
            threshold    = 8'hFE;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Signal > Threshold during Reset", test_num);

            rst = 1;
            signal_input = 8'd200;
            threshold    = 8'd50;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Signal vs Zero Threshold", test_num);
            reset_dut();
            signal_input = 8'd1;
            threshold    = 8'd0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pitch_detection Testbench");
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
        input expected_pitch_detected;
        begin
            if (expected_pitch_detected === (expected_pitch_detected ^ pitch_detected ^ expected_pitch_detected)) begin
                $display("PASS");
                $display("  Outputs: pitch_detected=%b",
                         pitch_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pitch_detected=%b",
                         expected_pitch_detected);
                $display("  Got:      pitch_detected=%b",
                         pitch_detected);
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
        $dumpvars(0,clk, rst, signal_input, threshold, pitch_detected);
    end

endmodule
