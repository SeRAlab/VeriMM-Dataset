`timescale 1ns/1ps

module deadbeat_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_state;
    reg rst;
    reg [3:0] setpoint;
    wire [3:0] control_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_control dut (
        .clk(clk),
        .current_state(current_state),
        .rst(rst),
        .setpoint(setpoint),
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
            current_state = 0;
            setpoint = 0;
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
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(4'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Zero Error (Setpoint == Current State)", test_num);
            reset_dut();
            current_state = 4'sd3;
            setpoint = 4'sd3;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'sd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Positive Step (Setpoint > Current State)", test_num);
            reset_dut();
            current_state = 4'sd0;
            setpoint = 4'sd5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'sd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Negative Step (Setpoint < Current State)", test_num);
            reset_dut();
            current_state = 4'sd0;
            setpoint = -4'sd4;
            @(posedge clk);
            #1;

            #1;


            check_outputs(-4'sd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Tracking from non-zero state", test_num);
            reset_dut();
            current_state = 4'sd2;
            setpoint = -4'sd1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(-4'sd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Positive correction from negative state", test_num);
            reset_dut();
            current_state = -4'sd4;
            setpoint = 4'sd2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'sd6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Boundary - Max positive control", test_num);
            reset_dut();
            current_state = -4'sd1;
            setpoint = 4'sd6;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'sd7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Boundary - Max negative control", test_num);
            reset_dut();
            current_state = 4'sd4;
            setpoint = -4'sd4;
            @(posedge clk);
            #1;

            #1;


            check_outputs(-4'sd8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deadbeat_control Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, current_state, rst, setpoint, control_output);
    end

endmodule
