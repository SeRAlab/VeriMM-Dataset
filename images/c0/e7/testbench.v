`timescale 1ns/1ps

module row_buf_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg datavalid;
    reg pix_in;
    wire pix_out1;
    wire pix_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    row_buf dut (
        .clk(clk),
        .datavalid(datavalid),
        .pix_in(pix_in),
        .pix_out1(pix_out1),
        .pix_out2(pix_out2)
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
        $display("row_buf Testbench");
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
        input expected_pix_out1;
        input expected_pix_out2;
        begin
            if (expected_pix_out1 === (expected_pix_out1 ^ pix_out1 ^ expected_pix_out1) &&
                expected_pix_out2 === (expected_pix_out2 ^ pix_out2 ^ expected_pix_out2)) begin
                $display("PASS");
                $display("  Outputs: pix_out1=%b, pix_out2=%b",
                         pix_out1, pix_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pix_out1=%b, pix_out2=%b",
                         expected_pix_out1, expected_pix_out2);
                $display("  Got:      pix_out1=%b, pix_out2=%b",
                         pix_out1, pix_out2);
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
        $dumpvars(0,clk, datavalid, pix_in, pix_out1, pix_out2);
    end

endmodule
