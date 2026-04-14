`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_state;
    reg [3:0] desired_state;
    reg reset;
    wire [3:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .current_state(current_state),
        .desired_state(desired_state),
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
            current_state = 4'd0;
            desired_state = 4'd0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: current=2, desired=5 (Expected: 3)");
            current_state = 4'd2;
            desired_state = 4'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: current=5, desired=2 (Expected: 13 [-3])");
            current_state = 4'd5;
            desired_state = 4'd2;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd13);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: current=10, desired=10 (Expected: 0)");
            current_state = 4'd10;
            desired_state = 4'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: current=0, desired=1 (Expected: 1)");
            current_state = 4'd0;
            desired_state = 4'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: current=1, desired=0 (Expected: 15 [-1])");
            current_state = 4'd1;
            desired_state = 4'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: current=0, desired=15 (Expected: 15)");
            current_state = 4'd0;
            desired_state = 4'd15;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase 007: current=15, desired=0 (Expected: 1)");
            current_state = 4'd15;
            desired_state = 4'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase 008: current=4, desired=12 (Expected: 8)");
            current_state = 4'd4;
            desired_state = 4'd12;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd8);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Testcase 009: current=12, desired=4 (Expected: 8 [-8])");
            current_state = 4'd12;
            desired_state = 4'd4;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd8);
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        $dumpvars(0,clk, current_state, desired_state, reset, control_signal);
    end

endmodule
