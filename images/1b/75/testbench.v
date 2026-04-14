`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] desired_output;
    reg [3:0] plant_output;
    reg rst;
    wire [3:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .desired_output(desired_output),
        .plant_output(plant_output),
        .rst(rst),
        .control_signal(control_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            desired_output = 0;
            plant_output = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Error (Target > Plant)", test_num);
            reset_dut();
            desired_output = 4'd10;
            plant_output = 4'd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Error", test_num);
            reset_dut();
            desired_output = 4'd5;
            plant_output = 4'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Error (Target < Plant)", test_num);
            reset_dut();
            desired_output = 4'd3;
            plant_output = 4'd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Scale Positive Error", test_num);
            reset_dut();
            desired_output = 4'd15;
            plant_output = 4'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Scale Negative Error", test_num);
            reset_dut();
            desired_output = 4'd0;
            plant_output = 4'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State Verification", test_num);
            rst = 1;
            desired_output = 4'd12;
            plant_output = 4'd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_control_signal;
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
        $dumpvars(0,clk, desired_output, plant_output, rst, control_signal);
    end

endmodule
