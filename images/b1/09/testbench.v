`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] reset_value;
    wire [7:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .reset(reset),
        .reset_value(reset_value),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [7:0] value;
        begin
            @(negedge clk);
            reset = 1;
            reset_value = value;
            @(negedge clk);
            reset = 0;
            reset_value = 8'h00;
        end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Resetting to 8'hA5");
        reset_dut(8'hA5);


        #1;



        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Single shift left from 8'h01");
        reset_dut(8'h01);
        @(negedge clk);
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Four shifts left from 8'h0F");
        reset_dut(8'h0F);
        repeat(4) @(negedge clk);
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Shift MSB (8'h80) out of register");
        reset_dut(8'h80);
        @(negedge clk);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Shift 8 times from 8'hFF");
        reset_dut(8'hFF);
        repeat(8) @(negedge clk);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Two shifts left from 8'h55");
        reset_dut(8'h55);
        repeat(2) @(negedge clk);

        #1;


        check_outputs(8'h54);
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
        input [7:0] expected_data;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
        $dumpvars(0,clk, reset, reset_value, data);
    end

endmodule
