`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] control_input;
    reg reset;
    wire [3:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .control_input(control_input),
        .reset(reset),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control_input = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test 001: Reset State Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: Simple Addition (0 + 5)");
            test_num = 2;
            reset_dut();
            control_input = 4'h5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: Accumulation over 3 cycles (2 + 3 + 4)");
            test_num = 3;
            reset_dut();
            control_input = 4'h2;
            @(posedge clk);
            #1;
            control_input = 4'h3;
            @(posedge clk);
            #1;
            control_input = 4'h4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: Wraparound Check (10 + 10)");
            test_num = 4;
            reset_dut();
            control_input = 4'hA;
            @(posedge clk);
            #1;
            control_input = 4'hA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h4);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: Large values and multiple overflows");
            test_num = 5;
            reset_dut();
            control_input = 4'hF;
            @(posedge clk);
            #1;
            control_input = 4'hF;
            @(posedge clk);
            #1;
            control_input = 4'h2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: Zero control input maintains state");
            test_num = 6;
            reset_dut();
            control_input = 4'h7;
            @(posedge clk);
            #1;
            control_input = 4'h0;
            @(posedge clk);
            #1;
            control_input = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h7);
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
        input [3:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, control_input, reset, state);
    end

endmodule
