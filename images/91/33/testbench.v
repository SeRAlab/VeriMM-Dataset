`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg LOAD;
    reg SER;
    reg SHIFT;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LOAD(LOAD),
        .SER(SER),
        .SHIFT(SHIFT),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        LOAD = 0;
        forever #5 LOAD = ~LOAD;
    end

        task reset_dut;

        begin
            SHIFT = 0;
            SER = 0;

            repeat(8) @(posedge LOAD);
            #2;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] pattern;
        begin
            reset_dut();
            test_num = 1;
            pattern = 8'hA5;

            for (i = 0; i < 8; i = i + 1) begin
                SER = pattern[i];
                @(posedge LOAD);
            end
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        integer i;
        begin
            reset_dut();
            test_num = 2;

            SER = 1;
            repeat(8) @(posedge LOAD);

            for (i = 0; i < 4; i = i + 1) begin
                @(negedge LOAD);
                SHIFT = 1;
                #2 SHIFT = 0;
            end
            #2;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            test_num = 3;


            SER = 0; repeat(7) @(posedge LOAD);
            SER = 1; @(posedge LOAD);


            for (i = 0; i < 7; i = i + 1) begin
                @(negedge LOAD);
                SHIFT = 1;
                #2 SHIFT = 0;
            end
            #2;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            test_num = 4;

            SER = 1;
            repeat(8) @(posedge LOAD);

            for (i = 0; i < 8; i = i + 1) begin
                @(negedge LOAD);
                SHIFT = 1;
                #2 SHIFT = 0;
            end
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            test_num = 5;


            for (i = 0; i < 4; i = i + 1) begin
                @(negedge LOAD);
                SER = 1;
                @(posedge LOAD);
                #2;
                SHIFT = 1;
                #2;
                SHIFT = 0;
            end
            #2;
            #1;

            check_outputs(8'h55);
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
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,LOAD, SER, SHIFT, Q);
    end

endmodule
