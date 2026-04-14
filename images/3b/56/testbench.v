`timescale 1ns/1ps

module PID_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] error;
    reg reset;
    wire [31:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PID_Controller dut (
        .clk(clk),
        .error(error),
        .reset(reset),
        .control_signal(control_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            error = 0;
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
            $display("\nTest Case %03d: Zero Error Test", test_num);
            reset_dut();

            error = 16'd0;
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Constant Error Test", test_num);
            reset_dut();

            error = 16'd10;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Increasing Error (Derivative) Test", test_num);
            reset_dut();

            error = 16'd10;
            @(posedge clk);
            #1;
            error = 16'd25;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd75);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Negative Error Test", test_num);
            reset_dut();

            error = -16'd10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hFFFFFFE2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Error Recovery Test", test_num);
            reset_dut();

            error = 16'd10;
            @(posedge clk);
            #1;
            error = 16'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd0);
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
        input [31:0] expected_control_signal;
        begin
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%h",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%h",
                         expected_control_signal);
                $display("  Got:      control_signal=%h",
                         control_signal);
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
        $dumpvars(0,clk, error, reset, control_signal);
    end

endmodule
