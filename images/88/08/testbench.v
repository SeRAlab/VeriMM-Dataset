`timescale 1ns/1ps

module binary_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] limit;
    reg reset;
    reg [2:0] state;
    wire [3:0] count;
    wire done;
    wire [2:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter dut (
        .clk(clk),
        .limit(limit),
        .reset(reset),
        .state(state),
        .count(count),
        .done(done),
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
            state = 3'b001;
            limit = 4'd0;
            @(posedge clk);
            #1;
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: IDLE State Transitions");
            reset_dut();
            state = 3'b001;
            limit = 4'd5;
            #2;
            #1;

            check_outputs(4'd0, 1'b0, 3'b010);
            test_num = test_num + 1;
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: COUNTING State (Below Limit)");
            reset_dut();
            state = 3'b010;
            limit = 4'd10;


            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd1, 1'b0, 3'b010);
            test_num = test_num + 1;
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Reaching the Limit");
            reset_dut();
            state = 3'b010;
            limit = 4'd2;

            @(posedge clk);
            #1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'd2, 1'b0, 3'b100);
            test_num = test_num + 1;
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: DONE State Logic");
            reset_dut();
            state = 3'b100;
            limit = 4'd5;
            #2;


            #1;



            check_outputs(count, 1'b1, 3'b001);
            test_num = test_num + 1;
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset mid-count");
            reset_dut();
            state = 3'b010;
            limit = 4'd8;
            @(posedge clk);
            #1;
            reset = 1;
            #10;
            reset = 0;
            state = 3'b001;
            #2;

            #1;


            check_outputs(4'd0, 1'b0, 3'b010);
            test_num = test_num + 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter Testbench");
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
        input [3:0] expected_count;
        input expected_done;
        input [2:0] expected_next_state;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: count=%h, done=%b, next_state=%h",
                         count, done, next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, done=%b, next_state=%h",
                         expected_count, expected_done, expected_next_state);
                $display("  Got:      count=%h, done=%b, next_state=%h",
                         count, done, next_state);
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
        $dumpvars(0,clk, limit, reset, state, count, done, next_state);
    end

endmodule
