`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg in_valid;
    reg rst;
    wire [7:0] out_data;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .in_data(in_data),
        .in_valid(in_valid),
        .rst(rst),
        .out_data(out_data),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_valid = 0;
            in_data = 8'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Downsampling Factor 2 (2:1)");
            reset_dut();


            @(posedge clk);
            in_data = 8'hA1; in_valid = 1;
            @(posedge clk);

            in_data = 8'hB2; in_valid = 1;
            @(posedge clk);
            in_valid = 0;


            repeat(1) @(posedge clk);


            #1;



            check_outputs(8'hA1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Upsampling Factor 0.5 (1:2) - First Sample");
            reset_dut();

            @(posedge clk);
            in_data = 8'hC3; in_valid = 1;
            @(posedge clk);
            in_valid = 0;


            @(posedge clk);
            #1;

            check_outputs(8'hC3, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Upsampling Factor 0.5 (1:2) - Second Sample");
            reset_dut();

            @(posedge clk);
            in_data = 8'hD4; in_valid = 1;
            @(posedge clk);
            in_valid = 0;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'hD4, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Idle State (No valid input)");
            reset_dut();

            in_valid = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Reset mid-operation");
            reset_dut();

            @(posedge clk);
            in_data = 8'hFF; in_valid = 1;
            @(posedge clk);
            rst = 1;
            @(posedge clk);

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
        input [7:0] expected_out_data;
        input expected_out_valid;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h, out_valid=%b",
                         out_data, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h, out_valid=%b",
                         expected_out_data, expected_out_valid);
                $display("  Got:      out_data=%h, out_valid=%b",
                         out_data, out_valid);
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
        $dumpvars(0,clk, in_data, in_valid, rst, out_data, out_valid);
    end

endmodule
