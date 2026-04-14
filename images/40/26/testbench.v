`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [1:0] symbol_in;
    wire [1:0] state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .rst(rst),
        .symbol_in(symbol_in),
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
            symbol_in = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Path to State 00");
            test_num = test_num + 1;
            reset_dut();

            symbol_in = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Path to State 10");
            test_num = test_num + 1;
            reset_dut();

            symbol_in = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Path to State 11 (00->10->11)");
            test_num = test_num + 1;
            reset_dut();

            symbol_in = 2'b11;
            @(posedge clk);

            #1 symbol_in = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Path to State 01 (00->10->01)");
            test_num = test_num + 1;
            reset_dut();

            symbol_in = 2'b11;
            @(posedge clk);

            #1 symbol_in = 2'b10;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Circular path back to State 00");
            test_num = test_num + 1;
            reset_dut();

            symbol_in = 2'b11;
            @(posedge clk);

            #1 symbol_in = 2'b10;
            @(posedge clk);

            #1 symbol_in = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Self-loop at State 11");
            test_num = test_num + 1;
            reset_dut();

            symbol_in = 2'b11; @(posedge clk);

            #1 symbol_in = 2'b01; @(posedge clk);

            #1 symbol_in = 2'b10; @(posedge clk);
            #1 #1;
 check_outputs(2'b11);
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
        input [1:0] expected_state_out;
        begin
            if (expected_state_out === (expected_state_out ^ state_out ^ expected_state_out)) begin
                $display("PASS");
                $display("  Outputs: state_out=%h",
                         state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_out=%h",
                         expected_state_out);
                $display("  Got:      state_out=%h",
                         state_out);
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
        $dumpvars(0,clk, rst, symbol_in, state_out);
    end

endmodule
