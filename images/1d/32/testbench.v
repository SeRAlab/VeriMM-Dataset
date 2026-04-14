`timescale 1ns/1ps

module PID_Controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Kd;
    reg [7:0] Ki;
    reg [7:0] Kp;
    reg clk;
    reg [7:0] error;
    reg rst;
    wire [7:0] control_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PID_Controller dut (
        .Kd(Kd),
        .Ki(Ki),
        .Kp(Kp),
        .clk(clk),
        .error(error),
        .rst(rst),
        .control_output(control_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            error = 0;
            Kp = 0;
            Ki = 0;
            Kd = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            Kp = 8'd10;
            Ki = 8'd5;
            Kd = 8'd2;
            error = 8'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            Kp = 8'd5;
            Ki = 8'd0;
            Kd = 8'd0;
            error = 8'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            Kp = 8'd0;
            Ki = 8'd2;
            Kd = 8'd0;
            error = 8'd5;
            @(posedge clk);
            error = 8'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd20);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            Kp = 8'd0;
            Ki = 8'd0;
            Kd = 8'd3;
            error = 8'd0;
            @(posedge clk);
            error = 8'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            Kp = 8'd2;
            Ki = 8'd1;
            Kd = 8'd1;
            error = 8'd10;
            @(posedge clk);
            error = 8'd20;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd80);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            Kp = 8'd2;
            Ki = 8'd1;
            Kd = 8'd5;
            error = 8'd10;
            @(posedge clk);
            error = 8'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd40);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PID_Controller Testbench");
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
        input [7:0] expected_control_output;
        begin
            if (expected_control_output === (expected_control_output ^ control_output ^ expected_control_output)) begin
                $display("PASS");
                $display("  Outputs: control_output=%h",
                         control_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_output=%h",
                         expected_control_output);
                $display("  Got:      control_output=%h",
                         control_output);
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
        $dumpvars(0,Kd, Ki, Kp, clk, error, rst, control_output);
    end

endmodule
