`timescale 1ns/1ps

module holes_filler_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg datavalid;
    reg pix_in_current;
    reg pix_in_previous;
    wire left;
    wire pix_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    holes_filler dut (
        .clk(clk),
        .datavalid(datavalid),
        .pix_in_current(pix_in_current),
        .pix_in_previous(pix_in_previous),
        .left(left),
        .pix_out(pix_out)
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
        $display("holes_filler Testbench");
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
        input expected_left;
        input expected_pix_out;
        begin
            if (expected_left === (expected_left ^ left ^ expected_left) &&
                expected_pix_out === (expected_pix_out ^ pix_out ^ expected_pix_out)) begin
                $display("PASS");
                $display("  Outputs: left=%b, pix_out=%b",
                         left, pix_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: left=%b, pix_out=%b",
                         expected_left, expected_pix_out);
                $display("  Got:      left=%b, pix_out=%b",
                         left, pix_out);
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
        $dumpvars(0,clk, datavalid, pix_in_current, pix_in_previous, left, pix_out);
    end

endmodule
