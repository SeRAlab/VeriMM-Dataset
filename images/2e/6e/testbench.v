`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] control_signal;
    reg [7:0] current_state;
    reg reset;
    wire [7:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .control_signal(control_signal),
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
            control_signal = 8'h00;
            current_state = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero Inputs", test_num);
            reset_dut();
            current_state = 8'h00;
            control_signal = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simple Prediction", test_num);
            reset_dut();
            current_state = 8'd10;
            control_signal = 8'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: High Control Influence", test_num);
            reset_dut();
            current_state = 8'd2;
            control_signal = 8'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd102);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State Dominance", test_num);
            reset_dut();
            current_state = 8'd200;
            control_signal = 8'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd201);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Arithmetic Overflow/Wrap", test_num);
            reset_dut();
            current_state = 8'd250;
            control_signal = 8'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Maximum Values", test_num);
            reset_dut();
            current_state = 8'hFF;
            control_signal = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFE);
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
        input [7:0] expected_next_state;
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
        $dumpvars(0,clk, control_signal, current_state, reset, next_state);
    end

endmodule
