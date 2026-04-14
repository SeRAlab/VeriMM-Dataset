`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] hidden_state;
    reg [7:0] input_vector;
    reg reset;
    wire [7:0] next_hidden_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .hidden_state(hidden_state),
        .input_vector(input_vector),
        .reset(reset),
        .next_hidden_state(next_hidden_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_vector = 8'h00;
            hidden_state = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All inputs zero", test_num);
            reset_dut();
            input_vector = 8'h00;
            hidden_state = 8'h00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive input saturation", test_num);
            reset_dut();
            input_vector = 8'h7F;
            hidden_state = 8'h00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative input saturation", test_num);
            reset_dut();
            input_vector = 8'h80;
            hidden_state = 8'h00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hC0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hidden state influence", test_num);
            reset_dut();
            input_vector = 8'h00;
            hidden_state = 8'h20;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Combined inputs", test_num);
            reset_dut();
            input_vector = 8'h10;
            hidden_state = 8'hF0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset behavior", test_num);
            reset_dut();
            input_vector = 8'h7F;
            hidden_state = 8'h7F;
            reset = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_cell Testbench");
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
        input [7:0] expected_next_hidden_state;
        begin
            if (expected_next_hidden_state === (expected_next_hidden_state ^ next_hidden_state ^ expected_next_hidden_state)) begin
                $display("PASS");
                $display("  Outputs: next_hidden_state=%h",
                         next_hidden_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_hidden_state=%h",
                         expected_next_hidden_state);
                $display("  Got:      next_hidden_state=%h",
                         next_hidden_state);
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
        $dumpvars(0,clk, hidden_state, input_vector, reset, next_hidden_state);
    end

endmodule
