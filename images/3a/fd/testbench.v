`timescale 1ns/1ps

module mpc_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_state;
    reg [7:0] reference_state;
    reg reset;
    wire [7:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_control dut (
        .clk(clk),
        .current_state(current_state),
        .reference_state(reference_state),
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
            current_state = 0;
            reference_state = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Error (State=50, Ref=50)", test_num);
            reset_dut();
            current_state = 8'd50;
            reference_state = 8'd50;

            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive Step (State=20, Ref=30)", test_num);
            reset_dut();
            current_state = 8'd20;
            reference_state = 8'd30;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Step (State=50, Ref=40)", test_num);
            reset_dut();
            current_state = 8'd50;
            reference_state = 8'd40;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Positive Step (State=0, Ref=100)", test_num);
            reset_dut();
            current_state = 8'd0;
            reference_state = 8'd100;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Negative Step (State=150, Ref=50)", test_num);
            reset_dut();
            current_state = 8'd150;
            reference_state = 8'd50;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h9C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Test (State=250, Ref=255)", test_num);
            reset_dut();
            current_state = 8'd250;
            reference_state = 8'd255;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd5);
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
        $dumpvars(0,clk, current_state, reference_state, reset, control_signal);
    end

endmodule
