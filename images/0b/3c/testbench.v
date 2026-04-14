`timescale 1ns/1ps

module state_space_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [1:0] state_in;
    wire [1:0] control_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_space_controller dut (
        .clk(clk),
        .reset(reset),
        .state_in(state_in),
        .control_out(control_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        state_in = 2'b00;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Checking Reset State (00)", test_num);
        reset_dut();

        #1;


        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Transition to State 01", test_num);
        reset_dut();
        state_in = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Transition to State 10", test_num);
        reset_dut();
        state_in = 2'b10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Transition to State 11", test_num);
        reset_dut();
        state_in = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Sequence Transition (00->10->11)", test_num);
        reset_dut();

        state_in = 2'b10;
        @(posedge clk);
        #1;

        state_in = 2'b11;
        @(posedge clk);
        #1;

        #1;


        check_outputs(2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Reset during operation", test_num);
        reset_dut();

        state_in = 2'b11;
        @(posedge clk);
        #1;


        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;

        #1;


        check_outputs(2'b00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("state_space_controller Testbench");
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
        input [1:0] expected_control_out;
        begin
            if (expected_control_out === (expected_control_out ^ control_out ^ expected_control_out)) begin
                $display("PASS");
                $display("  Outputs: control_out=%h",
                         control_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_out=%h",
                         expected_control_out);
                $display("  Got:      control_out=%h",
                         control_out);
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
        $dumpvars(0,clk, reset, state_in, control_out);
    end

endmodule
