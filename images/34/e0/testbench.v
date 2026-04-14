`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] state;
    wire [3:0] control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .rst(rst),
        .state(state),
        .control(control)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            state = 4'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: State > Threshold (12 > 8)", test_num);
            reset_dut();
            state = 4'd12;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: State < Threshold (3 < 8)", test_num);
            reset_dut();
            state = 4'd3;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: State at Threshold (8)", test_num);
            reset_dut();
            state = 4'd8;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State at Max (15)", test_num);
            reset_dut();
            state = 4'd15;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd14);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: State at Min (0)", test_num);
            reset_dut();
            state = 4'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: State slightly above Threshold (9)", test_num);
            reset_dut();
            state = 4'd9;
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
        input [3:0] expected_control;
        begin
            if (expected_control === (expected_control ^ control ^ expected_control)) begin
                $display("PASS");
                $display("  Outputs: control=%h",
                         control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control=%h",
                         expected_control);
                $display("  Got:      control=%h",
                         control);
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
        $dumpvars(0,clk, rst, state, control);
    end

endmodule
