`timescale 1ns/1ps

module simple_rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] hidden_state;
    reg [4:0] input_vector;
    reg rst;
    wire [4:0] output_vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_rnn_cell dut (
        .clk(clk),
        .hidden_state(hidden_state),
        .input_vector(input_vector),
        .rst(rst),
        .output_vector(output_vector)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_vector = 5'b0;
            hidden_state = 5'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            input_vector = 5'd5;
            hidden_state = 5'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            input_vector = 5'd0;
            hidden_state = 5'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            input_vector = 5'd31;
            hidden_state = 5'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            input_vector = 5'b01010;
            hidden_state = 5'b10101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            rst = 1;
            input_vector = 5'h1F;
            hidden_state = 5'h1F;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd0);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            input_vector = 5'd31;
            hidden_state = 5'd31;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd30);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_rnn_cell Testbench");
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
        input [4:0] expected_output_vector;
        begin
            if (expected_output_vector === (expected_output_vector ^ output_vector ^ expected_output_vector)) begin
                $display("PASS");
                $display("  Outputs: output_vector=%h",
                         output_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_vector=%h",
                         expected_output_vector);
                $display("  Got:      output_vector=%h",
                         output_vector);
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
        $dumpvars(0,clk, hidden_state, input_vector, rst, output_vector);
    end

endmodule
