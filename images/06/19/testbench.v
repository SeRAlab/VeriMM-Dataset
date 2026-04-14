`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] hidden_state;
    reg [1:0] input_data;
    wire [1:0] new_hidden_state;
    wire [1:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .hidden_state(hidden_state),
        .input_data(input_data),
        .new_hidden_state(new_hidden_state),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input_data = 2'b00;
            hidden_state = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            input_data = 2'd1;
            hidden_state = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2, 2'd2);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            input_data = 2'd2;
            hidden_state = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0, 2'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            input_data = 2'd3;
            hidden_state = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1, 2'd1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            input_data = 2'd3;
            hidden_state = 2'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2, 2'd2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            input_data = 2'd0;
            hidden_state = 2'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3, 2'd3);
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
        input [1:0] expected_new_hidden_state;
        input [1:0] expected_output_data;
        begin
            if (expected_new_hidden_state === (expected_new_hidden_state ^ new_hidden_state ^ expected_new_hidden_state) &&
                expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: new_hidden_state=%h, output_data=%h",
                         new_hidden_state, output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_hidden_state=%h, output_data=%h",
                         expected_new_hidden_state, expected_output_data);
                $display("  Got:      new_hidden_state=%h, output_data=%h",
                         new_hidden_state, output_data);
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
        $dumpvars(0,clk, hidden_state, input_data, new_hidden_state, output_data);
    end

endmodule
