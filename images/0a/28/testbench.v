`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] control_input;
    reg [3:0] current_state;
    reg reset;
    wire control_signal;
    wire [3:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .control_input(control_input),
        .current_state(current_state),
        .reset(reset),
        .control_signal(control_signal),
        .next_state(next_state)
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
        control_input = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: System Reset", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Prediction Below Target", test_num);
        reset_dut();
        current_state = 4'h2;
        control_input = 4'h3;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Reaching Target State", test_num);
        reset_dut();
        current_state = 4'h4;
        control_input = 4'h6;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 4'hA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Exceeding Target State", test_num);
        reset_dut();
        current_state = 4'h8;
        control_input = 4'h4;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 4'hC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Arithmetic Overflow", test_num);
        reset_dut();
        current_state = 4'hE;
        control_input = 4'h4;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 4'h2);
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
        input expected_control_signal;
        input [3:0] expected_next_state;
        begin
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal) &&
                expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%b, next_state=%h",
                         control_signal, next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%b, next_state=%h",
                         expected_control_signal, expected_next_state);
                $display("  Got:      control_signal=%b, next_state=%h",
                         control_signal, next_state);
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
        $dumpvars(0,clk, control_input, current_state, reset, control_signal, next_state);
    end

endmodule
