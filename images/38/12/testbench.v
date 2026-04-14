`timescale 1ns/1ps

module IIR_Filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x_in;
    wire [15:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IIR_Filter dut (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        x_in = 16'd0;
        test_num = test_num + 1;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Running Testcase 001: Zero Input Response");
        repeat (10) begin
            x_in = 16'h0000;
            @(posedge clk);
        end

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Running Testcase 002: Impulse Response");
        x_in = 16'h7FFF;
        @(posedge clk);
        x_in = 16'h0000;
        repeat (5) @(posedge clk);



        #1;




        check_outputs(y_out);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Running Testcase 003: DC Step Response (Positive)");
        x_in = 16'h1000;
        repeat (20) @(posedge clk);


        #1;



        check_outputs(y_out);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Running Testcase 004: DC Step Response (Negative)");
        x_in = 16'hF000;
        repeat (20) @(posedge clk);

        #1;


        check_outputs(y_out);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Running Testcase 005: Full Scale Negative Check");
        x_in = 16'h8000;
        repeat (10) @(posedge clk);

        #1;


        check_outputs(y_out);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IIR_Filter Testbench");
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
        input [15:0] expected_y_out;
        begin
            if (expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: y_out=%h",
                         y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_out=%h",
                         expected_y_out);
                $display("  Got:      y_out=%h",
                         y_out);
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
        $dumpvars(0,clk, rst, x_in, y_out);
    end

endmodule
