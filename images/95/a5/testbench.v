`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [1:0] op;
    reg reset;
    reg [15:0] writeData;
    wire [15:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .op(op),
        .reset(reset),
        .writeData(writeData),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        op = OP_RETAIN;
        writeData = 16'h0000;
        @(posedge clock);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %03d: Reset functionality check", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %03d: Load writeData (0xABCD)", test_num);
        reset_dut();
        @(posedge clock);
        op = OP_LOAD;
        writeData = 16'hABCD;
        @(posedge clock);
        #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %03d: Multiple increments", test_num);
        reset_dut();

        @(posedge clock);
        op = OP_LOAD;
        writeData = 16'h0005;
        @(posedge clock);

        op = OP_INC;
        repeat(3) @(posedge clock);
        #1;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %03d: Multiple decrements", test_num);
        reset_dut();

        @(posedge clock);
        op = OP_LOAD;
        writeData = 16'h000A;
        @(posedge clock);

        op = OP_DEC;
        repeat(4) @(posedge clock);
        #1;
        #1;

        check_outputs(16'h0006);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %03d: Retain value (Nop)", test_num);
        reset_dut();

        @(posedge clock);
        op = OP_LOAD;
        writeData = 16'h55AA;
        @(posedge clock);

        op = OP_RETAIN;
        repeat(5) @(posedge clock);
        #1;
        #1;

        check_outputs(16'h55AA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %03d: Increment wrap-around (FFFF to 0000)", test_num);
        reset_dut();
        @(posedge clock);
        op = OP_LOAD;
        writeData = 16'hFFFF;
        @(posedge clock);
        op = OP_INC;
        @(posedge clock);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %03d: Decrement wrap-around (0000 to FFFF)", test_num);
        reset_dut();

        @(posedge clock);
        op = OP_DEC;
        @(posedge clock);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %03d: Mixed operations (Load -> Inc -> Retain -> Dec)", test_num);
        reset_dut();
        @(posedge clock);
        op = OP_LOAD; writeData = 16'h1000;
        @(posedge clock);
        op = OP_INC;
        @(posedge clock);
        op = OP_RETAIN;
        @(posedge clock);
        op = OP_INC;
        @(posedge clock);
        op = OP_DEC;
        @(posedge clock);
        #1;
        #1;

        check_outputs(16'h1001);
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
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_data;
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
        $dumpvars(0,clock, op, reset, writeData, data);
    end

endmodule
