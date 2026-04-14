`timescale 1ns/1ps

module mpc_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] setpoint;
    reg [7:0] state;
    wire [7:0] control_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_control dut (
        .clk(clk),
        .rst(rst),
        .setpoint(setpoint),
        .state(state),
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
            setpoint = 0;
            state = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset state check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Positive error tracking", test_num);
            reset_dut();
            setpoint = 8'd100;
            state = 8'd40;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Zero error tracking", test_num);
            reset_dut();
            setpoint = 8'd50;
            state = 8'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Negative error tracking", test_num);
            reset_dut();
            setpoint = 8'd20;
            state = 8'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hE2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Maximum positive constraint check", test_num);
            reset_dut();
            setpoint = 8'd127;
            state = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Maximum negative constraint check", test_num);
            reset_dut();
            setpoint = 8'd0;
            state = 8'd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_control Testbench");
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
        $dumpvars(0,clk, rst, setpoint, state, control_output);
    end

endmodule
