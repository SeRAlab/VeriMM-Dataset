`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] hidden_state;
    reg [3:0] input_vector;
    reg reset;
    wire [3:0] new_hidden_state;
    wire [3:0] output_vector;

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
        .new_hidden_state(new_hidden_state),
        .output_vector(output_vector)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_vector = 4'b0;
            hidden_state = 4'b0;
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
            $display("Testcase %0d: Testing reset state", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero inputs after reset", test_num);
            reset_dut();
            input_vector = 4'h0;
            hidden_state = 4'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input vector 4'h5 with zero hidden state", test_num);
            reset_dut();
            input_vector = 4'h5;
            hidden_state = 4'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5, 4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 4'h3 and Hidden 4'h4", test_num);
            reset_dut();
            input_vector = 4'h3;
            hidden_state = 4'h4;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h7, 4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing overflow (4'hA + 4'h8)", test_num);
            reset_dut();
            input_vector = 4'hA;
            hidden_state = 4'h8;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h2, 4'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority during active inputs", test_num);
            reset_dut();
            input_vector = 4'hF;
            hidden_state = 4'hF;
            reset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h0);
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
        input [3:0] expected_new_hidden_state;
        input [3:0] expected_output_vector;
        begin
            if (expected_new_hidden_state === (expected_new_hidden_state ^ new_hidden_state ^ expected_new_hidden_state) &&
                expected_output_vector === (expected_output_vector ^ output_vector ^ expected_output_vector)) begin
                $display("PASS");
                $display("  Outputs: new_hidden_state=%h, output_vector=%h",
                         new_hidden_state, output_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_hidden_state=%h, output_vector=%h",
                         expected_new_hidden_state, expected_output_vector);
                $display("  Got:      new_hidden_state=%h, output_vector=%h",
                         new_hidden_state, output_vector);
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
        $dumpvars(0,clk, hidden_state, input_vector, reset, new_hidden_state, output_vector);
    end

endmodule
