`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] din;
    reg din_en;
    reg rst;
    reg [4:0] v1_reg;
    wire comp1;
    wire [31:0] dout;
    wire dout_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .din_en(din_en),
        .rst(rst),
        .v1_reg(v1_reg),
        .comp1(comp1),
        .dout(dout),
        .dout_en(dout_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            din = 32'h0;
            din_en = 0;
            v1_reg = 5'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Match lower 5 bits", test_num);

            v1_reg = 5'h0A;
            din = 32'h1234560A;
            din_en = 1;
            @(posedge clk);
            #1 din_en = 0;


            repeat(2) @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 32'h1234560A, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Mismatch lower 5 bits", test_num);

            v1_reg = 5'h1F;
            din = 32'h1234560A;
            din_en = 1;
            @(posedge clk);
            #1 din_en = 0;

            repeat(2) @(posedge clk);

            #1 #1;
 check_outputs(1'b0, 32'h1234560A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All ones match", test_num);

            v1_reg = 5'h1F;
            din = 32'hFFFFFFFF;
            din_en = 1;
            @(posedge clk);
            #1 din_en = 0;

            repeat(2) @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Match with zero", test_num);

            v1_reg = 5'h00;
            din = 32'hAAAAAAA0;
            din_en = 1;
            @(posedge clk);
            #1 din_en = 0;

            repeat(2) @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 32'hAAAAAAA0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Check empty status", test_num);



            #1 #1;
 check_outputs(1'b0, 32'h0, 1'b0);
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
        input expected_comp1;
        input [31:0] expected_dout;
        input expected_dout_en;
        begin
            if (expected_comp1 === (expected_comp1 ^ comp1 ^ expected_comp1) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_dout_en === (expected_dout_en ^ dout_en ^ expected_dout_en)) begin
                $display("PASS");
                $display("  Outputs: comp1=%b, dout=%h, dout_en=%b",
                         comp1, dout, dout_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp1=%b, dout=%h, dout_en=%b",
                         expected_comp1, expected_dout, expected_dout_en);
                $display("  Got:      comp1=%b, dout=%h, dout_en=%b",
                         comp1, dout, dout_en);
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
        $dumpvars(0,clk, din, din_en, rst, v1_reg, comp1, dout, dout_en);
    end

endmodule
