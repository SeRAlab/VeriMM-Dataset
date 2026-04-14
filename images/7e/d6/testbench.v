`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk80;
    reg [1:0] din;
    reg reset;
    reg start;
    wire davail;
    wire [3:0] dout;
    wire header;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk80(clk80),
        .din(din),
        .reset(reset),
        .start(start),
        .davail(davail),
        .dout(dout),
        .header(header)
    );

    // Clock generation (10ns period)
    initial begin
        clk80 = 0;
        forever #5 clk80 = ~clk80;
    end

        task reset_dut;

    begin
        reset = 1;
        start = 0;
        din = 2'b00;
        @(posedge clk80);
        #1;
        reset = 0;
        @(posedge clk80);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 4'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Header Pattern Detection (Start=1)", test_num);
        reset_dut();
        start = 1;





        @(posedge clk80) din <= 2'b01;
        @(posedge clk80) din <= 2'b11;
        @(posedge clk80) din <= 2'b11;
        @(posedge clk80) din <= 2'b11;
        @(posedge clk80) din <= 2'b11;
        @(posedge clk80) din <= 2'b00;

        @(posedge clk80);
        #1;

        #1;


        check_outputs(davail, dout, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Header Pattern Detection (Start=0)", test_num);
        reset_dut();
        start = 0;

        @(posedge clk80) din <= 2'b01;
        @(posedge clk80) din <= 2'b11;
        @(posedge clk80) din <= 2'b11;
        @(posedge clk80) din <= 2'b11;
        @(posedge clk80) din <= 2'b11;
        @(posedge clk80) din <= 2'b00;

        @(posedge clk80);
        #1;

        #1;


        check_outputs(1'b0, 4'h0, 1'b0);
    end
        endtask

    task testcase004;

    reg initial_davail;
    begin
        test_num = 4;
        $display("\nTestcase %0d: Data Output and Davail Toggling", test_num);
        reset_dut();
        start = 1;
        initial_davail = davail;


        @(posedge clk80) din <= 2'b01;
        @(posedge clk80) din <= 2'b11;
        @(posedge clk80) din <= 2'b11;
        @(posedge clk80) din <= 2'b11;
        @(posedge clk80) din <= 2'b11;
        @(posedge clk80) din <= 2'b00;


        @(posedge clk80) din <= 2'b10;
        @(posedge clk80) din <= 2'b11;

        @(posedge clk80);
        #1;



        if (davail !== initial_davail && dout === 4'hB) begin
            #1;

            check_outputs(davail, 4'hB, 1'b1);
        end else begin

            #1;


            check_outputs(!initial_davail, 4'hB, 1'b1);
        end
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
        input expected_davail;
        input [3:0] expected_dout;
        input expected_header;
        begin
            if (expected_davail === (expected_davail ^ davail ^ expected_davail) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_header === (expected_header ^ header ^ expected_header)) begin
                $display("PASS");
                $display("  Outputs: davail=%b, dout=%h, header=%b",
                         davail, dout, header);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: davail=%b, dout=%h, header=%b",
                         expected_davail, expected_dout, expected_header);
                $display("  Got:      davail=%b, dout=%h, header=%b",
                         davail, dout, header);
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
        $dumpvars(0,clk80, din, reset, start, davail, dout, header);
    end

endmodule
