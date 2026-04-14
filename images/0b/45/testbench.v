`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    reg [127:0] state_in;
    wire done;
    wire [127:0] state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .state_in(state_in),
        .done(done),
        .state_out(state_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            state_in = 128'b0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros Input", test_num);
            reset_dut();
            state_in = 128'h00000000000000000000000000000000;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 128'h63636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones Input", test_num);
            reset_dut();
            state_in = 128'h01010101010101010101010101010101;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 128'h7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: FIPS-197 Intermediate Vector", test_num);
            reset_dut();

            state_in = 128'h193de3bea0f4e22b9ac68d2ae9f84808;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 128'h046681e5e0cb199a48f8d8be2806264c);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_round Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input expected_done;
        input [127:0] expected_state_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_state_out === (expected_state_out ^ state_out ^ expected_state_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, state_out=%h",
                         done, state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, state_out=%h",
                         expected_done, expected_state_out);
                $display("  Got:      done=%b, state_out=%h",
                         done, state_out);
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
        $dumpvars(0,clk, rst, start, state_in, done, state_out);
    end

endmodule
