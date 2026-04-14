`timescale 1ns/1ps

module debounce_tb;

    // Testbench signals (sequential circuit)
    reg btn_in;
    reg clk;
    reg rst_n;
    wire btn_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    debounce dut (
        .btn_in(btn_in),
        .clk(clk),
        .rst_n(rst_n),
        .btn_out(btn_out)
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
        $display("debounce Testbench");
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
        input expected_btn_out;
        begin
            if (expected_btn_out === (expected_btn_out ^ btn_out ^ expected_btn_out)) begin
                $display("PASS");
                $display("  Outputs: btn_out=%b",
                         btn_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: btn_out=%b",
                         expected_btn_out);
                $display("  Got:      btn_out=%b",
                         btn_out);
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
        $dumpvars(0,btn_in, clk, rst_n, btn_out);
    end

endmodule
