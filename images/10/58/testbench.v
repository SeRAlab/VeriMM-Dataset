`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] control_input;
    reg reset;
    reg [7:0] setpoint;
    wire [7:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .control_input(control_input),
        .reset(reset),
        .setpoint(setpoint),
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
            control_input = 0;
            setpoint = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            setpoint = 8'd100;
            control_input = 8'd10;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            setpoint = 8'd45;
            control_input = 8'd20;
            repeat(3) @(posedge clk);

            #1;
            #1;

            check_outputs(8'd45);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            setpoint = 8'd200;
            control_input = 8'd100;
            repeat(2) @(posedge clk);


            setpoint = 8'd150;
            control_input = 8'd10;
            repeat(2) @(posedge clk);

            #1;
            #1;

            check_outputs(8'd180);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            setpoint = 8'd100;
            control_input = 8'd50;
            repeat(1) @(posedge clk);

            control_input = 8'd0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_controller Testbench");
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
        input [7:0] expected_output_signal;
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
        $dumpvars(0,clk, control_input, reset, setpoint, output_signal);
    end

endmodule
