`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    wire [2:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .LED(LED)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 8'h00;


            repeat (8) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in all ones", test_num);
            reset_dut();
            repeat (8) begin
                data = 8'h01;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in all zeros", test_num);
            reset_dut();
            repeat (8) begin
                data = 8'h00;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] seq;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 1000 0001 (MSB=1, Bit3=0, LSB=1)", test_num);
            reset_dut();
            seq = 8'b10000001;
            for(i=7; i>=0; i=i-1) begin
                data = {7'b0, seq[i]};
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] seq;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 0000 1000 (MSB=0, Bit3=1, LSB=0)", test_num);
            reset_dut();
            seq = 8'b00001000;
            for(i=7; i>=0; i=i-1) begin
                data = {7'b0, seq[i]};
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] seq;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 1111 1000 (MSB=1, Bit3=1, LSB=0)", test_num);
            reset_dut();
            seq = 8'b11111000;
            for(i=7; i>=0; i=i-1) begin
                data = {7'b0, seq[i]};
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(3'b110);
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
        input [2:0] expected_LED;
        begin
            if (expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: LED=%h",
                         LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h",
                         expected_LED);
                $display("  Got:      LED=%h",
                         LED);
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
        $dumpvars(0,clk, data, LED);
    end

endmodule
