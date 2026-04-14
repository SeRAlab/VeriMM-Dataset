`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] port;
    reg reset;
    wire [31:0] out;
    wire write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .port(port),
        .reset(reset),
        .out(out),
        .write(write)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            port = 6'b0;
            @(posedge clk);
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Simple Packet Reception", test_num);
            reset_dut();



            @(posedge clk); port = 6'h21;
            @(posedge clk); port = 6'h22;
            @(posedge clk); port = 6'h23;
            @(posedge clk); port = 6'h24;
            @(posedge clk); port = 6'h25;
            @(posedge clk); port = 6'h26;
            @(posedge clk); port = 6'h27;
            @(posedge clk); port = 6'h28;


            @(posedge clk);
            port = 6'h0;



            #1;




            check_outputs(32'h12345678, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Reset during reception", test_num);
            reset_dut();

            @(posedge clk); port = 6'h2A;
            @(posedge clk); port = 6'h2B;


            reset = 1;
            @(posedge clk);
            reset = 0;


            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Back-to-back packets", test_num);
            reset_dut();


            repeat(8) begin
                @(posedge clk); port = 6'h3F;
            end
            @(posedge clk);


            repeat(8) begin
                @(posedge clk); port = 6'h11;
            end
            @(posedge clk);


            #1;



            check_outputs(32'h11111111, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Incomplete packet check", test_num);
            reset_dut();

            @(posedge clk); port = 6'h2F;
            @(posedge clk); port = 6'h2F;

            @(posedge clk); port = 6'h00;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(out, 1'b0);
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
        input [31:0] expected_out;
        input expected_write;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_write === (expected_write ^ write ^ expected_write)) begin
                $display("PASS");
                $display("  Outputs: out=%h, write=%b",
                         out, write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, write=%b",
                         expected_out, expected_write);
                $display("  Got:      out=%h, write=%b",
                         out, write);
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
        $dumpvars(0,clk, port, reset, out, write);
    end

endmodule
