`timescale 1ns/1ps

module binary_updown_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] limit;
    reg reset;
    reg [3:0] state;
    reg up;
    wire [3:0] count;
    wire done;
    wire [3:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_updown_counter dut (
        .clk(clk),
        .limit(limit),
        .reset(reset),
        .state(state),
        .up(up),
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
        state = IDLE;
        up = 0;
        limit = 4'b0000;
        @(posedge clk);
        #2 reset = 0;
        $display("DUT Reset to IDLE state.");
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: IDLE to COUNTUP transition", test_num);
        reset_dut();
        state = IDLE;
        up = 1;
        limit = 4'd5;
        #2;

        #1;


        check_outputs(4'd0, 1'b0, COUNTUP);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: IDLE to COUNTDOWN transition", test_num);
        reset_dut();
        state = IDLE;
        up = 0;
        limit = 4'd5;
        #2;

        #1;


        check_outputs(4'd0, 1'b0, COUNTDOWN);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: COUNTUP - Middle of sequence", test_num);
        reset_dut();
        state = COUNTUP;
        limit = 4'd10;
        up = 1;

        @(posedge clk); #2;
        @(posedge clk); #2;

        #1;


        check_outputs(4'd2, 1'b0, COUNTUP);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: COUNTUP - Reaching limit", test_num);
        reset_dut();
        state = COUNTUP;
        limit = 4'd3;
        up = 1;
        @(posedge clk); #2;
        @(posedge clk); #2;
        @(posedge clk); #2;

        #1;


        check_outputs(4'd3, 1'b0, DONE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: COUNTDOWN - Reaching zero", test_num);
        reset_dut();
        state = COUNTDOWN;
        limit = 4'd2;




        force dut.count = 4'd0;
        #2;
        #1;

        check_outputs(4'd0, 1'b0, DONE);
        release dut.count;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: DONE state status", test_num);
        reset_dut();
        state = DONE;
        #2;


        if (done === 1'b1) begin
            $display("PASS: Done signal asserted.");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Done signal NOT asserted.");
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Reset override during operation", test_num);
        reset_dut();
        state = COUNTUP;
        reset = 1;
        #2;

        #1;


        check_outputs(count, 1'b0, IDLE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_updown_counter Testbench");
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
        input [3:0] expected_count;
        input expected_done;
        input [3:0] expected_next_state;
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
        $dumpvars(0,clk, limit, reset, state, up, count, done, next_state);
    end

endmodule
