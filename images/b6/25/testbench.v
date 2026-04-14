`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [16:0] divisor;
    reg [17:0] init;
    reg load;
    reg next_point;
    reg positive;
    reg [16:0] q;
    reg [16:0] r;
    reg sys_clk;
    wire [17:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .divisor(divisor),
        .init(init),
        .load(load),
        .next_point(next_point),
        .positive(positive),
        .q(q),
        .r(r),
        .sys_clk(sys_clk),
        .o(o)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

    begin
        load = 0;
        next_point = 0;
        init = 0;
        positive = 0;
        q = 0;
        r = 0;
        divisor = 0;
        @(posedge sys_clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        init = 18'd100;
        q = 17'd10;
        r = 17'd0;
        divisor = 17'd50;
        positive = 1'b1;
        load = 1'b1;
        @(posedge sys_clk);
        #1 load = 1'b0;


        next_point = 1'b1;
        @(posedge sys_clk);
        #1 next_point = 1'b0;


        #1;



        check_outputs(18'd110);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        init = 18'd100;
        q = 17'd10;
        r = 17'd0;
        divisor = 17'd50;
        positive = 1'b0;
        load = 1'b1;
        @(posedge sys_clk);
        #1 load = 1'b0;

        next_point = 1'b1;
        @(posedge sys_clk);
        #1 next_point = 1'b0;


        #1;



        check_outputs(18'd90);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        init = 18'd0;
        q = 17'd5;
        r = 17'd30;
        divisor = 17'd50;
        positive = 1'b1;
        load = 1'b1;
        @(posedge sys_clk);
        #1 load = 1'b0;

        next_point = 1'b1;
        @(posedge sys_clk);
        #1 next_point = 1'b0;


        #1;



        check_outputs(18'd6);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        init = 18'd50;
        q = 17'd5;
        r = 17'd30;
        divisor = 17'd50;
        positive = 1'b0;
        load = 1'b1;
        @(posedge sys_clk);
        #1 load = 1'b0;

        next_point = 1'b1;
        @(posedge sys_clk);
        #1 next_point = 1'b0;


        #1;



        check_outputs(18'd44);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        init = 18'd0;
        q = 17'd2;
        r = 17'd6;
        divisor = 17'd20;
        positive = 1'b1;
        load = 1'b1;
        @(posedge sys_clk);
        #1 load = 1'b0;


        next_point = 1'b1;
        @(posedge sys_clk);



        @(posedge sys_clk);
        #1 next_point = 1'b0;

        #1;


        check_outputs(18'd5);
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
        input [17:0] expected_o;
        begin
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
        $dumpvars(0,divisor, init, load, next_point, positive, q, r, sys_clk, o);
    end

endmodule
