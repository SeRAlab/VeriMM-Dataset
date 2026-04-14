`timescale 1ns/1ps

module memdev_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [14:0] i_wb_addr;
    reg i_wb_cyc;
    reg [31:0] i_wb_data;
    reg i_wb_stb;
    reg i_wb_we;
    wire o_wb_ack;
    wire [31:0] o_wb_data;
    wire o_wb_stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memdev dut (
        .i_clk(i_clk),
        .i_wb_addr(i_wb_addr),
        .i_wb_cyc(i_wb_cyc),
        .i_wb_data(i_wb_data),
        .i_wb_stb(i_wb_stb),
        .i_wb_we(i_wb_we),
        .o_wb_ack(o_wb_ack),
        .o_wb_data(o_wb_data),
        .o_wb_stall(o_wb_stall)
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
        $display("memdev Testbench");
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
        input expected_o_wb_ack;
        input [31:0] expected_o_wb_data;
        input expected_o_wb_stall;
        begin
            if (expected_o_wb_ack === (expected_o_wb_ack ^ o_wb_ack ^ expected_o_wb_ack) &&
                expected_o_wb_data === (expected_o_wb_data ^ o_wb_data ^ expected_o_wb_data) &&
                expected_o_wb_stall === (expected_o_wb_stall ^ o_wb_stall ^ expected_o_wb_stall)) begin
                $display("PASS");
                $display("  Outputs: o_wb_ack=%b, o_wb_data=%h, o_wb_stall=%b",
                         o_wb_ack, o_wb_data, o_wb_stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_wb_ack=%b, o_wb_data=%h, o_wb_stall=%b",
                         expected_o_wb_ack, expected_o_wb_data, expected_o_wb_stall);
                $display("  Got:      o_wb_ack=%b, o_wb_data=%h, o_wb_stall=%b",
                         o_wb_ack, o_wb_data, o_wb_stall);
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
        $dumpvars(0,i_clk, i_wb_addr, i_wb_cyc, i_wb_data, i_wb_stb, i_wb_we, o_wb_ack, o_wb_data, o_wb_stall);
    end

endmodule
