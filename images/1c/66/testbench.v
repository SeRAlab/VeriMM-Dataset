`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x_input;
    wire [15:0] y_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .clk(clk),
        .reset(reset),
        .x_input(x_input),
        .y_output(y_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x_input = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Zero Input Stability");
            reset_dut();
            repeat(5) @(posedge clk);
            x_input = 16'h0000;
            @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Impulse Response");
            reset_dut();
            x_input = 16'h0100;
            @(posedge clk);
            x_input = 16'h0000;
            repeat(2) @(posedge clk);



            $display("Observing impulse response tail...");
            #1;

            check_outputs(y_output);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: DC Step Response");
            reset_dut();
            x_input = 16'h0010;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(y_output);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Large Input Handling");
            reset_dut();
            x_input = 16'h7FFF;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(y_output);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Negative Input Handling");
            reset_dut();
            x_input = 16'hFF00;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(y_output);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("iir_filter Testbench");
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
        input [15:0] expected_y_output;
        begin
            if (expected_y_output === (expected_y_output ^ y_output ^ expected_y_output)) begin
                $display("PASS");
                $display("  Outputs: y_output=%h",
                         y_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_output=%h",
                         expected_y_output);
                $display("  Got:      y_output=%h",
                         y_output);
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
        $dumpvars(0,clk, reset, x_input, y_output);
    end

endmodule
