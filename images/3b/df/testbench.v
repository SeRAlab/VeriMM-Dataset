`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input_data;
    wire [3:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .input_data(input_data),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            input_data = 0;
            @(posedge clk);
            #1 rst_n = 1;
            $display("DUT Reset performed.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Single Input (Input: 4, Expected: 4)");
            input_data = 4;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h4);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Two Steps (Inputs: 2, 3, Expected: 5)");
            input_data = 2;
            @(posedge clk);
            #1 input_data = 3;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Modulo Arithmetic (Inputs: 10, 10, Expected: 4)");
            input_data = 10;
            @(posedge clk);
            #1 input_data = 10;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case 004: Five Steps (Input: 1, 1, 1, 1, 1, Expected: 5)");
            input_data = 1; @(posedge clk);
            input_data = 1; @(posedge clk);
            input_data = 1; @(posedge clk);
            input_data = 1; @(posedge clk);
            input_data = 1; @(posedge clk);
            #1 #1;
 check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case 005: Large values (Input: 15, 15, 15, Expected: 13)");



            input_data = 15; @(posedge clk);
            input_data = 15; @(posedge clk);
            input_data = 15; @(posedge clk);
            #1 #1;
 check_outputs(4'hd);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test Case 006: Zero Input (Input: 7, 0, 0, Expected: 7)");
            input_data = 7; @(posedge clk);
            input_data = 0; @(posedge clk);
            input_data = 0; @(posedge clk);
            #1 #1;
 check_outputs(4'h7);
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
        input [3:0] expected_output_data;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
        $dumpvars(0,clk, input_data, output_data);
    end

endmodule
