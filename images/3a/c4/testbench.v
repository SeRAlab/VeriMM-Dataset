`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] current_state;
    reg [2:0] desired_state;
    wire [2:0] control_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .current_state(current_state),
        .desired_state(desired_state),
        .control_output(control_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            current_state = 3'b000;
            desired_state = 3'b000;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Move from 000 to 111", test_num);
            reset_dut();
            current_state = 3'b000;
            desired_state = 3'b111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Move from 101 to 010", test_num);
            reset_dut();
            current_state = 3'b101;
            desired_state = 3'b010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maintain state 100", test_num);
            reset_dut();
            current_state = 3'b100;
            desired_state = 3'b100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Move from 001 to 110", test_num);
            reset_dut();
            current_state = 3'b001;
            desired_state = 3'b110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset to 000", test_num);
            reset_dut();
            current_state = 3'b111;
            desired_state = 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000);
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
        input [2:0] expected_control_output;
        begin
            if (expected_control_output === (expected_control_output ^ control_output ^ expected_control_output)) begin
                $display("PASS");
                $display("  Outputs: control_output=%h",
                         control_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_output=%h",
                         expected_control_output);
                $display("  Got:      control_output=%h",
                         control_output);
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
        $dumpvars(0,clk, current_state, desired_state, control_output);
    end

endmodule
