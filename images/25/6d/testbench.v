`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg received_bit;
    reg reset;
    reg start;
    wire done;
    wire [2:0] state_path;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .received_bit(received_bit),
        .reset(reset),
        .start(start),
        .done(done),
        .state_path(state_path)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            received_bit = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            start = 1;
            received_bit = 0;
            @(posedge clk);
            start = 0;

            repeat (4) begin
                received_bit = 0;
                @(posedge clk);
            end

            wait (done == 1);
            #1;

            check_outputs(1'b1, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            start = 1;
            received_bit = 1;
            @(posedge clk);
            start = 0;

            repeat (4) begin
                received_bit = 1;
                @(posedge clk);
            end
            wait (done == 1);
            #1;

            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            start = 1;
            received_bit = 0;
            @(posedge clk);
            start = 0;

            received_bit = 0; @(posedge clk);
            received_bit = 0; @(posedge clk);
            received_bit = 1; @(posedge clk);
            received_bit = 0; @(posedge clk);
            wait (done == 1);

            #1;


            check_outputs(1'b1, 3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            start = 1;
            received_bit = 1;
            @(posedge clk);
            start = 0;
            received_bit = 0; @(posedge clk);
            received_bit = 1; @(posedge clk);
            received_bit = 0; @(posedge clk);
            wait (done == 1);

            #1;


            check_outputs(1'b1, 3'b010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("viterbi_decoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [2:0] expected_state_path;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_state_path === (expected_state_path ^ state_path ^ expected_state_path)) begin
                $display("PASS");
                $display("  Outputs: done=%b, state_path=%h",
                         done, state_path);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, state_path=%h",
                         expected_done, expected_state_path);
                $display("  Got:      done=%b, state_path=%h",
                         done, state_path);
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
        $dumpvars(0,clk, received_bit, reset, start, done, state_path);
    end

endmodule
