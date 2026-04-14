`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [63:0] input_value;
    reg write_enable;
    wire [31:0] Rout_hi;
    wire [31:0] Rout_low;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .input_value(input_value),
        .write_enable(write_enable),
        .Rout_hi(Rout_hi),
        .Rout_low(Rout_low)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        clr = 1;
        write_enable = 0;
        input_value = 0;
        @(posedge clk);
        clr = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Writing 64-bit value", test_num);
        reset_dut();
        @(posedge clk);
        write_enable = 1;
        input_value = 64'hAABBCCDD11223344;
        @(posedge clk);
        write_enable = 0;
        #1;

        check_outputs(32'hAABBCCDD, 32'h11223344);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Hold value when write_enable is low", test_num);
        reset_dut();

        @(posedge clk);
        write_enable = 1;
        input_value = 64'h1234567809abcdef;
        @(posedge clk);

        write_enable = 0;
        input_value = 64'hFFFFFFFFFFFFFFFF;
        @(posedge clk);
        #1;

        check_outputs(32'h12345678, 32'h09abcdef);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Synchronous Clear Priority", test_num);
        reset_dut();
        @(posedge clk);

        clr = 1;
        write_enable = 1;
        input_value = 64'h55555555AAAAAAA;
        @(posedge clk);
        clr = 0;
        write_enable = 0;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Writing all ones", test_num);
        reset_dut();
        @(posedge clk);
        write_enable = 1;
        input_value = 64'hFFFFFFFFFFFFFFFF;
        @(posedge clk);
        write_enable = 0;
        #1;

        check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Sequential writes", test_num);
        reset_dut();
        @(posedge clk);
        write_enable = 1;
        input_value = 64'h1111111122222222;
        @(posedge clk);
        input_value = 64'h3333333344444444;
        @(posedge clk);
        write_enable = 0;
        #1;

        check_outputs(32'h33333333, 32'h44444444);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_Rout_hi;
        input [31:0] expected_Rout_low;
        begin
            if (expected_Rout_hi === (expected_Rout_hi ^ Rout_hi ^ expected_Rout_hi) &&
                expected_Rout_low === (expected_Rout_low ^ Rout_low ^ expected_Rout_low)) begin
                $display("PASS");
                $display("  Outputs: Rout_hi=%h, Rout_low=%h",
                         Rout_hi, Rout_low);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Rout_hi=%h, Rout_low=%h",
                         expected_Rout_hi, expected_Rout_low);
                $display("  Got:      Rout_hi=%h, Rout_low=%h",
                         Rout_hi, Rout_low);
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
        $dumpvars(0,clk, clr, input_value, write_enable, Rout_hi, Rout_low);
    end

endmodule
