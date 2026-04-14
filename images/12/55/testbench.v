`timescale 1ns/1ps

module mpc_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] control_input;
    reg [3:0] current_state;
    reg reset;
    wire [3:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_fsm dut (
        .clk(clk),
        .control_input(control_input),
        .current_state(current_state),
        .reset(reset),
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
            control_input = 2'b00;
            current_state = 4'h0;
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
            $display("\nTestcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transition from 4'h0 with input 2'b01", test_num);
            reset_dut();
            current_state = 4'h0;
            control_input = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transition from 4'h5 with input 2'b10", test_num);
            reset_dut();
            current_state = 4'h5;
            control_input = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Boundary Transition from 4'hF with input 2'b01", test_num);
            reset_dut();
            current_state = 4'hF;
            control_input = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Transition from 4'hA with input 2'b11", test_num);
            reset_dut();
            current_state = 4'hA;
            control_input = 2'b11;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Hold state transition (Input 2'b00)", test_num);
            reset_dut();
            current_state = 4'h8;
            control_input = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_fsm Testbench");
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
        input [3:0] expected_next_state;
        begin
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h",
                         next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h",
                         expected_next_state);
                $display("  Got:      next_state=%h",
                         next_state);
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
        $dumpvars(0,clk, control_input, current_state, reset, next_state);
    end

endmodule
