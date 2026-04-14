`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_value;
    reg reset;
    reg [7:0] setpoint;
    wire [7:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .current_value(current_value),
        .reset(reset),
        .setpoint(setpoint),
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
            current_value = 0;
            setpoint = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Zero Error");
            reset_dut();
            setpoint = 8'd100;
            current_value = 8'd100;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Positive Error");
            reset_dut();
            setpoint = 8'd150;
            current_value = 8'd100;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd50);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Negative Error");
            reset_dut();
            setpoint = 8'd50;
            current_value = 8'd100;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'd206);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Maximum Step");
            reset_dut();
            setpoint = 8'd255;
            current_value = 8'd0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Multi-step convergence");
            reset_dut();
            setpoint = 8'd200;
            current_value = 8'd0;
            @(posedge clk);

            current_value = 8'd150;
            @(posedge clk);


            #1;



            check_outputs(8'd50);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Reset Mid-Operation");
            reset_dut();
            setpoint = 8'd100;
            current_value = 8'd20;
            @(posedge clk);
            reset = 1;
            @(posedge clk);

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
        $display("deadbeat_controller Testbench");
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
        input [7:0] expected_control_signal;
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
        $dumpvars(0,clk, current_value, reset, setpoint, control_signal);
    end

endmodule
