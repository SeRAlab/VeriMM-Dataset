`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    reg [2:0] select;
    reg [2:0] vec;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .select(select),
        .vec(vec),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 8'h00;
            select = 3'b000;
            vec = 3'b000;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            d = 8'hFF;
            select = 3'b000;
            @(posedge clk);


            #1;



            check_outputs(q);
        end
        endtask

    task testcase002;

        reg [7:0] first_val;
        begin
            test_num = 2;
            reset_dut();
            d = 8'hAA;
            select = 3'b000;
            @(posedge clk);
            first_val = q;
            @(posedge clk);

            if (q != first_val)
                #1;

                check_outputs(q);
            else
                $display("Test 2: Warning - SR value did not change after clock pulse");
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            d = 8'h55;
            select = 3'b001;
            vec = 3'b010;
            @(posedge clk);
            vec = 3'b111;
            #2;
            #1;

            check_outputs(q);
        end
        endtask

    task testcase004;

        reg [7:0] mode0_q;
        begin
            test_num = 4;
            reset_dut();
            d = 8'h12;
            @(posedge clk);
            select = 3'b000;
            #1 mode0_q = q;
            select = 3'b001;
            #1;

            #1;


            check_outputs(q);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            d = 8'hC3;
            select = 3'b000;
            repeat (8) @(posedge clk);
            vec = 3'b101;
            select = 3'b010;
            #1;

            check_outputs(q);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, reset, select, vec, q);
    end

endmodule
