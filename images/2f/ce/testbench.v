`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid_in;
    wire [7:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Basic functionality - Single valid sample");
            reset_dut();


            valid_in = 1'b1;
            data_in = 8'hA5;
            @(posedge clk);


            valid_in = 1'b0;
            data_in = 8'h00;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Idle state - No valid input");
            reset_dut();


            valid_in = 1'b0;
            data_in = 8'hFF;
            repeat(2) @(posedge clk);

            #1;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Back-to-back sample sets");
            reset_dut();


            valid_in = 1'b1; data_in = 8'h11; @(posedge clk);
            valid_in = 1'b0; data_in = 8'h00; @(posedge clk);


            valid_in = 1'b1; data_in = 8'h22; @(posedge clk);
            valid_in = 1'b0; data_in = 8'h00; @(posedge clk);

            #1;
            #1;

            check_outputs(8'h22, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Reset mid-operation");
            reset_dut();


            valid_in = 1'b1;
            data_in = 8'hCC;
            @(posedge clk);


            rst = 1'b1;
            @(posedge clk);
            #1;
            rst = 1'b0;


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
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
        input [7:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data_in, rst, valid_in, data_out, valid_out);
    end

endmodule
