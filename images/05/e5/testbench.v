`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] in;
    reg reset;
    wire out;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .out(out),
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
            in = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros sequence", test_num);
            reset_dut();

            in = 2'b00; @(posedge clk); #1;
            in = 2'b00; @(posedge clk); #1;
            in = 2'b00; @(posedge clk); #1;

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 1 -> 0", test_num);
            reset_dut();

            in = 2'b11; @(posedge clk); #1;
            in = 2'b10; @(posedge clk); #1;


            #1;



            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 1 -> 1 -> 0", test_num);
            reset_dut();

            in = 2'b11; @(posedge clk); #1;
            in = 2'b01; @(posedge clk); #1;
            in = 2'b01; @(posedge clk); #1;

            #1;


            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Error Correction (Single bit flip)", test_num);
            reset_dut();

            in = 2'b11; @(posedge clk); #1;
            in = 2'b00; @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence of 1s", test_num);
            reset_dut();

            in = 2'b11; @(posedge clk); #1;
            in = 2'b01; @(posedge clk); #1;
            in = 2'b10; @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 2'b11);
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
        input expected_out;
        input [1:0] expected_state;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: out=%b, state=%h",
                         out, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, state=%h",
                         expected_out, expected_state);
                $display("  Got:      out=%b, state=%h",
                         out, state);
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
        $dumpvars(0,clk, in, reset, out, state);
    end

endmodule
