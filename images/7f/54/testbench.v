`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        load = 1;
        data_in = 8'h00;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Basic Parallel Load (0xA5)");
        reset_dut();
        load = 1;
        data_in = 8'hA5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Single Shift Right");
        reset_dut();
        load = 1;
        data_in = 8'hFF;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase003;

    integer i;
    begin
        $display("Testcase 003: Multiple Shifts (4 times)");
        reset_dut();
        load = 1;
        data_in = 8'h80;
        @(posedge clk);
        #1;
        load = 0;
        for (i = 0; i < 4; i = i + 1) begin
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase004;

    integer i;
    begin
        $display("Testcase 004: Shift out all bits");
        reset_dut();
        load = 1;
        data_in = 8'h01;
        @(posedge clk);
        #1;
        load = 0;
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Consecutive Load Operations");
        reset_dut();
        load = 1;
        data_in = 8'h55;
        @(posedge clk);
        #1;
        data_in = 8'hAA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Shift Right with LSB 0");
        reset_dut();
        load = 1;
        data_in = 8'hFE;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
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
        $dumpvars(0,clk, data_in, load, data_out);
    end

endmodule
