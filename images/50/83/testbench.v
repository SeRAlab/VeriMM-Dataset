`timescale 1ns/1ps

module dual_port_ram_16x8_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr_a;
    reg [3:0] addr_b;
    reg clk;
    reg [7:0] data_in_a;
    reg we_a;
    wire [7:0] data_out_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_ram_16x8 dut (
        .addr_a(addr_a),
        .addr_b(addr_b),
        .clk(clk),
        .data_in_a(data_in_a),
        .we_a(we_a),
        .data_out_b(data_out_b)
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
        $display("dual_port_ram_16x8 Testbench");
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
        input [7:0] expected_data_out_b;
        begin
            if (expected_data_out_b === (expected_data_out_b ^ data_out_b ^ expected_data_out_b)) begin
                $display("PASS");
                $display("  Outputs: data_out_b=%h",
                         data_out_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_b=%h",
                         expected_data_out_b);
                $display("  Got:      data_out_b=%h",
                         data_out_b);
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
        $dumpvars(0,addr_a, addr_b, clk, data_in_a, we_a, data_out_b);
    end

endmodule
