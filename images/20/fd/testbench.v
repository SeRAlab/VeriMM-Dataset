`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 8'h00;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Checking Reset functionality...", test_num);
        reset_dut();
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = 2;
        $display("Testcase %03d: Shifting in 8 consecutive ones...", test_num);
        reset_dut();
        for (i = 0; i < 8; i = i + 1) begin
            data_in = 8'h01;
            @(posedge clk);
        end
        #1 #1;
 check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    integer i;
    reg [7:0] pattern;
    begin
        test_num = 3;
        pattern = 8'h55;
        $display("Testcase %03d: Shifting in pattern 0x55 (01010101)...", test_num);
        reset_dut();


        for (i = 7; i >= 0; i = i - 1) begin
            data_in = {7'b0, pattern[i]};
            @(posedge clk);
        end
        #1 #1;
 check_outputs(8'h55);
    end
        endtask

    task testcase004;

    integer i;
    reg [7:0] pattern;
    begin
        test_num = 4;
        pattern = 8'hAA;
        $display("Testcase %03d: Shifting in pattern 0xAA (10101010)...", test_num);
        reset_dut();
        for (i = 7; i >= 0; i = i - 1) begin
            data_in = {7'b0, pattern[i]};
            @(posedge clk);
        end
        #1 #1;
 check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    integer i;
    reg [11:0] sequence;
    begin
        test_num = 5;

        sequence = 12'hF5A;
        $display("Testcase %03d: Checking overflow with 12-bit sequence...", test_num);
        reset_dut();
        for (i = 11; i >= 0; i = i - 1) begin
            data_in = {7'b0, sequence[i]};
            @(posedge clk);
        end
        #1 #1;
 check_outputs(8'h5A);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rst, data_out);
    end

endmodule
