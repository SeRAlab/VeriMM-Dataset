`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA_IN;
    reg LOAD;
    reg reset;
    reg up;
    wire [7:0] Q;
    wire Q7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .LOAD(LOAD),
        .reset(reset),
        .up(up),
        .Q(Q),
        .Q7(Q7)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            reset = 1;
            LOAD = 0;
            up = 0;
            DATA_IN = 8'h00;
            @(posedge CLK);
            #1;
            reset = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            up = 1;
            LOAD = 1;
            DATA_IN = 8'hFF;
            @(posedge CLK); #1;

            #1;


            check_outputs(8'h01, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            up = 1;
            LOAD = 1;
            DATA_IN = 8'h55;
            @(posedge CLK); #1;

            LOAD = 0;
            up = 1;
            @(posedge CLK); #1;

            #1;


            check_outputs(8'h02, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            up = 0;
            LOAD = 1;
            DATA_IN = 8'hF0;
            @(posedge CLK); #1;

            #1;


            check_outputs(8'hF0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            up = 1;
            LOAD = 1;
            DATA_IN = 8'h80;
            @(posedge CLK); #1;
            LOAD = 0;
            @(posedge CLK); #1;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            up = 0;
            LOAD = 1;
            DATA_IN = 8'h80;
            @(posedge CLK); #1;
            LOAD = 0;
            @(posedge CLK); #1;
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
        input [7:0] expected_Q;
        input expected_Q7;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q7 === (expected_Q7 ^ Q7 ^ expected_Q7)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, Q7=%b",
                         Q, Q7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, Q7=%b",
                         expected_Q, expected_Q7);
                $display("  Got:      Q=%h, Q7=%b",
                         Q, Q7);
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
        $dumpvars(0,CLK, DATA_IN, LOAD, reset, up, Q, Q7);
    end

endmodule
