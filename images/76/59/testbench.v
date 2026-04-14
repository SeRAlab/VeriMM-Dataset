`timescale 1ns/1ps

module reg_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg en;
    reg reset;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_32bit dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        en = 0;
        data_in = 32'h0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Reset functionality");
        reset_dut();

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Basic write (Enable=1)");
        reset_dut();
        en = 1;
        data_in = 32'h12345678;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Write attempt with Enable=0");
        reset_dut();
        en = 0;
        data_in = 32'hABCDEF01;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Data retention when Enable is toggled");
        reset_dut();

        en = 1;
        data_in = 32'h5555AAAA;
        @(posedge clk);

        #1 en = 0;
        data_in = 32'hFFFFFFFF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h5555AAAA);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Boundary value check (0xFFFFFFFF)");
        reset_dut();
        en = 1;
        data_in = 32'hFFFFFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Asynchronous reset mid-cycle");
        reset_dut();
        en = 1;
        data_in = 32'h87654321;
        @(posedge clk);
        #2;
        reset = 1;
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_32bit Testbench");
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, en, reset, data_out);
    end

endmodule
