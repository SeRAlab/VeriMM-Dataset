`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallelin;
    reg rstn;
    reg shift;
    wire lsbout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .parallelin(parallelin),
        .rstn(rstn),
        .shift(shift),
        .lsbout(lsbout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            load = 0;
            shift = 0;
            parallelin = 8'b0;
            @(posedge clk);
            #1 rstn = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            parallelin = 8'b10101011;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            parallelin = 8'b11111110;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            parallelin = 8'b00000001;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            shift = 1;
            @(posedge clk);
            #1 shift = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            parallelin = 8'b11111111;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift = 1;

            repeat(3) @(posedge clk);
            #1 shift = 0;

            parallelin = 8'b00000001;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(1'b1);
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
        input expected_lsbout;
        begin
            if (expected_lsbout === (expected_lsbout ^ lsbout ^ expected_lsbout)) begin
                $display("PASS");
                $display("  Outputs: lsbout=%b",
                         lsbout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lsbout=%b",
                         expected_lsbout);
                $display("  Got:      lsbout=%b",
                         lsbout);
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
        $dumpvars(0,clk, load, parallelin, rstn, shift, lsbout);
    end

endmodule
