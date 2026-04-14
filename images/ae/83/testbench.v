`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clk;
    wire b;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .b(b),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: 0 -> 1 transition", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            a = 1;
            @(posedge clk);

            #1 a = 0;
            @(posedge clk);
            #2;
            $display("Test %0d: 1 -> 0 transition", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Test %0d: Maintain state 1", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 0;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Test %0d: Maintain state 0", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 1;
            @(posedge clk);


            @(posedge clk);
            a = 0;
            #2;

            $display("Test %0d: Edge sampling check (a changed at clk edge)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 1;
            @(negedge clk);
            #2;
            $display("Test %0d: Falling edge insensitivity check", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_b;
        input expected_state;
        begin
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: b=%b, state=%b",
                         b, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%b, state=%b",
                         expected_b, expected_state);
                $display("  Got:      b=%b, state=%b",
                         b, state);
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
        $dumpvars(0,a, clk, b, state);
    end

endmodule
