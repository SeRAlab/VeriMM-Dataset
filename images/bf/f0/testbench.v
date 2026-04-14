`timescale 1ns/1ps

module clock_switch3_basic_tb;

    // Testbench signals (sequential circuit)
    reg clk0_i;
    reg clk1_i;
    reg clk2_i;
    reg enable;
    reg rst0_i;
    reg rst1_i;
    reg rst2_i;
    reg [1:0] select;
    wire clk_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_switch3_basic dut (
        .clk0_i(clk0_i),
        .clk1_i(clk1_i),
        .clk2_i(clk2_i),
        .enable(enable),
        .rst0_i(rst0_i),
        .rst1_i(rst1_i),
        .rst2_i(rst2_i),
        .select(select),
        .clk_o(clk_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk0_i = 0;
        forever #5 clk0_i = ~clk0_i;
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
        $display("clock_switch3_basic Testbench");
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
        input expected_clk_o;
        begin
            if (expected_clk_o === (expected_clk_o ^ clk_o ^ expected_clk_o)) begin
                $display("PASS");
                $display("  Outputs: clk_o=%b",
                         clk_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_o=%b",
                         expected_clk_o);
                $display("  Got:      clk_o=%b",
                         clk_o);
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
        $dumpvars(0,clk0_i, clk1_i, clk2_i, enable, rst0_i, rst1_i, rst2_i, select, clk_o);
    end

endmodule
