`timescale 1ns/1ps

module window_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg datavalid;
    reg pix_in_current;
    reg pix_in_previous;
    wire A;
    wire B;
    wire C;
    wire D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    window dut (
        .clk(clk),
        .datavalid(datavalid),
        .pix_in_current(pix_in_current),
        .pix_in_previous(pix_in_previous),
        .A(A),
        .B(B),
        .C(C),
        .D(D)
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
        $display("window Testbench");
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
        input expected_A;
        input expected_B;
        input expected_C;
        input expected_D;
        begin
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_B === (expected_B ^ B ^ expected_B) &&
                expected_C === (expected_C ^ C ^ expected_C) &&
                expected_D === (expected_D ^ D ^ expected_D)) begin
                $display("PASS");
                $display("  Outputs: A=%b, B=%b, C=%b, D=%b",
                         A, B, C, D);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%b, B=%b, C=%b, D=%b",
                         expected_A, expected_B, expected_C, expected_D);
                $display("  Got:      A=%b, B=%b, C=%b, D=%b",
                         A, B, C, D);
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
        $dumpvars(0,clk, datavalid, pix_in_current, pix_in_previous, A, B, C, D);
    end

endmodule
