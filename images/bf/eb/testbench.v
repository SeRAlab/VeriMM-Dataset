`timescale 1ns/1ps

module generic_sram_line_en_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] i_address;
    reg i_clk;
    reg [127:0] i_write_data;
    reg i_write_enable;
    wire [127:0] o_read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    generic_sram_line_en dut (
        .i_address(i_address),
        .i_clk(i_clk),
        .i_write_data(i_write_data),
        .i_write_enable(i_write_enable),
        .o_read_data(o_read_data)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
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
        $display("generic_sram_line_en Testbench");
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
        input [127:0] expected_o_read_data;
        begin
            if (expected_o_read_data === (expected_o_read_data ^ o_read_data ^ expected_o_read_data)) begin
                $display("PASS");
                $display("  Outputs: o_read_data=%h",
                         o_read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_read_data=%h",
                         expected_o_read_data);
                $display("  Got:      o_read_data=%h",
                         o_read_data);
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
        $dumpvars(0,i_address, i_clk, i_write_data, i_write_enable, o_read_data);
    end

endmodule
