`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] setpoint;
    reg [3:0] state;
    wire [3:0] control_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
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
            state = 0;
            setpoint = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Delta (Setpoint > State)", test_num);
            reset_dut();
            state = 4'd2;
            setpoint = 4'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Delta (Setpoint == State)", test_num);
            reset_dut();
            state = 4'd5;
            setpoint = 4'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Delta (Setpoint < State)", test_num);
            reset_dut();
            state = 4'd7;
            setpoint = 4'd3;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Range Transition", test_num);
            reset_dut();
            state = 4'd0;
            setpoint = 4'd15;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Smallest Negative Transition", test_num);
            reset_dut();
            state = 4'd1;
            setpoint = 4'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset Verification", test_num);
            reset_dut();
            state = 4'd4;
            setpoint = 4'd9;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
            rst = 0;
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
        input [3:0] expected_control_output;
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
