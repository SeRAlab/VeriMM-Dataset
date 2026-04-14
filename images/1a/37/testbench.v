`timescale 1ns/1ps

module pid_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] process_variable;
    reg reset;
    reg [15:0] setpoint;
    wire [15:0] derivative;
    wire [15:0] integral;
    wire [15:0] proportional;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pid_controller dut (
        .clk(clk),
        .process_variable(process_variable),
        .reset(reset),
        .setpoint(setpoint),
        .derivative(derivative),
        .integral(integral),
        .proportional(proportional)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            process_variable = 0;
            setpoint = 0;
            reset = 1;
            repeat (2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Steady positive error", test_num);
            reset_dut();

            @(posedge clk);
            setpoint = 16'd100;
            process_variable = 16'd80;

            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(16'h0000, 16'h0028, 16'h0014);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Changing error (Step response)", test_num);
            reset_dut();

            @(posedge clk);
            setpoint = 16'd100;
            process_variable = 16'd50;

            @(posedge clk);
            process_variable = 16'd70;

            @(posedge clk);
            #1;



            #1;




            check_outputs(16'hFFEC, 16'h0050, 16'h001E);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero error condition", test_num);
            reset_dut();

            @(posedge clk);
            setpoint = 16'd500;
            process_variable = 16'd500;

            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Negative error (Overshoot)", test_num);
            reset_dut();

            @(posedge clk);
            setpoint = 16'd50;
            process_variable = 16'd40;

            @(posedge clk);
            process_variable = 16'd60;

            @(posedge clk);
            #1;



            #1;




            check_outputs(16'hFFEC, 16'h0000, 16'hFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Small step with negative derivative", test_num);
            reset_dut();

            @(posedge clk);
            setpoint = 16'd10;
            process_variable = 16'd0;

            @(posedge clk);
            process_variable = 16'd5;

            @(posedge clk);
            #1;



            #1;




            check_outputs(16'hFFFB, 16'h000F, 16'h0005);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pid_controller Testbench");
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
        input [15:0] expected_derivative;
        input [15:0] expected_integral;
        input [15:0] expected_proportional;
        begin
            if (expected_derivative === (expected_derivative ^ derivative ^ expected_derivative) &&
                expected_integral === (expected_integral ^ integral ^ expected_integral) &&
                expected_proportional === (expected_proportional ^ proportional ^ expected_proportional)) begin
                $display("PASS");
                $display("  Outputs: derivative=%h, integral=%h, proportional=%h",
                         derivative, integral, proportional);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: derivative=%h, integral=%h, proportional=%h",
                         expected_derivative, expected_integral, expected_proportional);
                $display("  Got:      derivative=%h, integral=%h, proportional=%h",
                         derivative, integral, proportional);
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
        $dumpvars(0,clk, process_variable, reset, setpoint, derivative, integral, proportional);
    end

endmodule
