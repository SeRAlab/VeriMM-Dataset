`timescale 1ns/1ps

module a429_rx_iface_tb;

    // Testbench signals (sequential circuit)
    reg a429_in_a;
    reg a429_in_b;
    reg clk2M;
    reg enable;
    reg parcheck;
    reg reset;
    reg [1:0] speed;
    wire [31:0] data;
    wire wr_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    a429_rx_iface dut (
        .a429_in_a(a429_in_a),
        .a429_in_b(a429_in_b),
        .clk2M(clk2M),
        .enable(enable),
        .parcheck(parcheck),
        .reset(reset),
        .speed(speed),
        .data(data),
        .wr_en(wr_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk2M = 0;
        forever #5 clk2M = ~clk2M;
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
        $display("a429_rx_iface Testbench");
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
        input [31:0] expected_data;
        input expected_wr_en;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_wr_en === (expected_wr_en ^ wr_en ^ expected_wr_en)) begin
                $display("PASS");
                $display("  Outputs: data=%h, wr_en=%b",
                         data, wr_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, wr_en=%b",
                         expected_data, expected_wr_en);
                $display("  Got:      data=%h, wr_en=%b",
                         data, wr_en);
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
        $dumpvars(0,a429_in_a, a429_in_b, clk2M, enable, parcheck, reset, speed, data, wr_en);
    end

endmodule
