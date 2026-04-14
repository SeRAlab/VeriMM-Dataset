`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] _input;
    reg clk;
    reg reset;
    reg switchRead;
    reg switchWrite;
    wire haveData;
    wire [31:0] output_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        ._input(_input),
        .clk(clk),
        .reset(reset),
        .switchRead(switchRead),
        .switchWrite(switchWrite),
        .haveData(haveData),
        .output_(output_)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            _input = 0;
            switchRead = 0;
            switchWrite = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Initial State", test_num);

            #1;


            check_outputs(1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Single Write/Read Cycle", test_num);


            _input = 16'hA5A5;
            switchRead = 1;
            @(posedge clk);
            #1;
            switchRead = 0;



            switchWrite = 1;
            @(posedge clk);
            #1;

            @(posedge clk);
            #1;
            switchWrite = 0;

            #1;


            check_outputs(1'b1, 32'h0000A5A5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Multi-Write Retrieval", test_num);


            _input = 16'h1111; switchRead = 1; @(posedge clk); #1;

            _input = 16'h2222; @(posedge clk); #1;

            _input = 16'h3333; @(posedge clk); #1;
            switchRead = 0;


            switchWrite = 1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            switchWrite = 0;


            #1;



            check_outputs(1'b0, 32'h00002222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Data Availability Flag", test_num);


            _input = 16'hFFFF;
            switchRead = 1;
            @(posedge clk);
            #1;
            switchRead = 0;


            #1;



            check_outputs(1'b1, 32'h0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Fill RAM Capacity", test_num);

            switchRead = 1;
            for (i = 0; i < 32; i = i + 1) begin
                _input = i[15:0];
                @(posedge clk);
                #1;
            end
            switchRead = 0;



            #1;




            check_outputs(1'b0, 32'h0);
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
        input expected_haveData;
        input [31:0] expected_output_;
        begin
            if (expected_haveData === (expected_haveData ^ haveData ^ expected_haveData) &&
                expected_output_ === (expected_output_ ^ output_ ^ expected_output_)) begin
                $display("PASS");
                $display("  Outputs: haveData=%b, output_=%h",
                         haveData, output_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: haveData=%b, output_=%h",
                         expected_haveData, expected_output_);
                $display("  Got:      haveData=%b, output_=%h",
                         haveData, output_);
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
        $dumpvars(0,_input, clk, reset, switchRead, switchWrite, haveData, output_);
    end

endmodule
