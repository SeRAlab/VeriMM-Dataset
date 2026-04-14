`timescale 1ns/1ps

module out_stage_tb;

    // Testbench signals (sequential circuit)
    reg DONE;
    reg [7:0] In_byte;
    reg clk;
    reg reset;
    wire CEO;
    wire [7:0] Out_byte;
    wire RE;
    wire [7:0] RdAdd;
    wire Valid_out;
    wire out_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    out_stage dut (
        .DONE(DONE),
        .In_byte(In_byte),
        .clk(clk),
        .reset(reset),
        .CEO(CEO),
        .Out_byte(Out_byte),
        .RE(RE),
        .RdAdd(RdAdd),
        .Valid_out(Valid_out),
        .out_done(out_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("out_stage Testbench");
        $display("========================================");


        
        
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
        input expected_CEO;
        input [7:0] expected_Out_byte;
        input expected_RE;
        input [7:0] expected_RdAdd;
        input expected_Valid_out;
        input expected_out_done;
        begin
            if (expected_CEO === (expected_CEO ^ CEO ^ expected_CEO) &&
                expected_Out_byte === (expected_Out_byte ^ Out_byte ^ expected_Out_byte) &&
                expected_RE === (expected_RE ^ RE ^ expected_RE) &&
                expected_RdAdd === (expected_RdAdd ^ RdAdd ^ expected_RdAdd) &&
                expected_Valid_out === (expected_Valid_out ^ Valid_out ^ expected_Valid_out) &&
                expected_out_done === (expected_out_done ^ out_done ^ expected_out_done)) begin
                $display("PASS");
                $display("  Outputs: CEO=%b, Out_byte=%h, RE=%b, RdAdd=%h, Valid_out=%b, out_done=%b",
                         CEO, Out_byte, RE, RdAdd, Valid_out, out_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CEO=%b, Out_byte=%h, RE=%b, RdAdd=%h, Valid_out=%b, out_done=%b",
                         expected_CEO, expected_Out_byte, expected_RE, expected_RdAdd, expected_Valid_out, expected_out_done);
                $display("  Got:      CEO=%b, Out_byte=%h, RE=%b, RdAdd=%h, Valid_out=%b, out_done=%b",
                         CEO, Out_byte, RE, RdAdd, Valid_out, out_done);
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
        $dumpvars(0,DONE, In_byte, clk, reset, CEO, Out_byte, RE, RdAdd, Valid_out, out_done);
    end

endmodule
