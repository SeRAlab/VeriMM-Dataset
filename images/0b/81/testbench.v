`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control_signal;
    reg [3:0] current_state;
    reg [3:0] input_signal;
    reg rst;
    wire [3:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .control_signal(control_signal),
        .current_state(current_state),
        .input_signal(input_signal),
        .rst(rst),
        .next_state(next_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            control_signal = 0;
            current_state = 0;
            input_signal = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic addition (5 + 3 = 8)", test_num);
            current_state = 4'd5;
            input_signal = 4'd3;
            control_signal = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Hold state (Control=0, 10 + 5 should stay 10)", test_num);
            current_state = 4'd10;
            input_signal = 4'd5;
            control_signal = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Saturation check (12 + 7 = 15 constraint)", test_num);
            current_state = 4'd12;
            input_signal = 4'd7;
            control_signal = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Boundary condition (10 + 5 = 15)", test_num);
            current_state = 4'd10;
            input_signal = 4'd5;
            control_signal = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Zero input (7 + 0 = 7)", test_num);
            current_state = 4'd7;
            input_signal = 4'd0;
            control_signal = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Hold maximum value with control low", test_num);
            current_state = 4'd15;
            input_signal = 4'd15;
            control_signal = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Sequential logic check", test_num);

            current_state = 4'd2;
            input_signal = 4'd2;
            control_signal = 1'b1;
            @(posedge clk);
            #2;

            current_state = next_state;
            input_signal = 4'd10;
            control_signal = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd4);
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
        $dumpvars(0,clk, control_signal, current_state, input_signal, rst, next_state);
    end

endmodule
