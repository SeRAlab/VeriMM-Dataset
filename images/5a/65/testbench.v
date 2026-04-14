`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    wire [31:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .checksum(checksum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        data = 0;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        data = 8'h11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00130012);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        data = 8'h11;
        @(posedge clk);

        #1 data = 8'h22;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00470034);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        data = 8'h00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00020001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        data = 8'hFF;
        @(posedge clk);

        #1 data = 8'hFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h030001FF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        data = 8'h61; @(posedge clk);

        #1 data = 8'h62; @(posedge clk);

        #1 data = 8'h63; @(posedge clk);
        #1;
        #1;

        check_outputs(32'h024E0127);
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
        input [31:0] expected_checksum;
        begin
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h",
                         checksum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h",
                         expected_checksum);
                $display("  Got:      checksum=%h",
                         checksum);
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
        $dumpvars(0,clk, data, checksum);
    end

endmodule
