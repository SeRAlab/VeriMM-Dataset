`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA_IN;
    reg LOAD;
    reg SER_IN;
    wire [7:0] Q;
    wire SER_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .LOAD(LOAD),
        .SER_IN(SER_IN),
        .Q(Q),
        .SER_OUT(SER_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            LOAD = 1;
            DATA_IN = 8'h00;
            SER_IN = 0;
            @(posedge CLK);
            #1;
            LOAD = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Parallel Load 8'hA5", test_num);
            @(negedge CLK);
            LOAD = 1;
            DATA_IN = 8'hA5;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Load 8'h00 then shift in 1", test_num);

            @(negedge CLK);
            LOAD = 0;
            SER_IN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Load 8'hFF then shift in 0", test_num);
            @(negedge CLK);
            LOAD = 1;
            DATA_IN = 8'hFF;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SER_IN = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'hFE, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Load 8'h01 then shift left 3 times with SER_IN=1", test_num);
            @(negedge CLK);
            LOAD = 1;
            DATA_IN = 8'h01;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SER_IN = 1;
            repeat(3) @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h0F, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Load 8'h80 and shift left with SER_IN=0", test_num);
            @(negedge CLK);
            LOAD = 1;
            DATA_IN = 8'h80;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SER_IN = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_Q;
        input expected_SER_OUT;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_SER_OUT === (expected_SER_OUT ^ SER_OUT ^ expected_SER_OUT)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, SER_OUT=%b",
                         Q, SER_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, SER_OUT=%b",
                         expected_Q, expected_SER_OUT);
                $display("  Got:      Q=%h, SER_OUT=%b",
                         Q, SER_OUT);
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
        $dumpvars(0,CLK, DATA_IN, LOAD, SER_IN, Q, SER_OUT);
    end

endmodule
