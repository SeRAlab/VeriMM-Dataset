`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg miso;
    wire cs;
    wire mosi;
    wire [9:0] pay;
    wire [9:0] pby;
    wire sck;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .miso(miso),
        .cs(cs),
        .mosi(mosi),
        .pay(pay),
        .pby(pby),
        .sck(sck)
    );

        task reset_dut;

        begin
            miso = 0;


            repeat(10) @(posedge clk);
            if (cs !== 1'b1) begin
                wait(cs == 1);
            end
            repeat(5) @(posedge clk);
        end
        endtask
    task send_serial_data;

        input [19:0] data_stream;
        integer i;
        begin

            wait(cs == 0);



            for (i = 19; i >= 0; i = i - 1) begin
                @(negedge sck);
                miso = data_stream[i];
            end

            wait(cs == 1);
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Normal positioning (100, 250)", test_num);


            fork
                send_serial_data({10'd100, 10'd250});
            join



            #1;




            check_outputs(1'b1, mosi, 10'd100, 10'd250, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Minimum boundary (0, 0)", test_num);

            fork
                send_serial_data({10'd0, 10'd0});
            join

            #1;


            check_outputs(1'b1, mosi, 10'd0, 10'd0, 1'b1);
        end
        endtask

    task testcase003;

        reg [9:0] val_a, val_b;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Out of bounds (Limiter check)", test_num);

            fork
                send_serial_data({10'd1023, 10'd1023});
            join



            if (pay < 10'd1023 && pby < 10'd1023) begin

                #1;


                check_outputs(1'b1, mosi, pay, pby, 1'b1);
            end else begin
                $display("FAIL: Limiter did not restrict paddle coordinates.");
                fail_count = fail_count + 1;
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
        input expected_cs;
        input expected_mosi;
        input [9:0] expected_pay;
        input [9:0] expected_pby;
        input expected_sck;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_pay === (expected_pay ^ pay ^ expected_pay) &&
                expected_pby === (expected_pby ^ pby ^ expected_pby) &&
                expected_sck === (expected_sck ^ sck ^ expected_sck)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, mosi=%b, pay=%h, pby=%h, sck=%b",
                         cs, mosi, pay, pby, sck);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, mosi=%b, pay=%h, pby=%h, sck=%b",
                         expected_cs, expected_mosi, expected_pay, expected_pby, expected_sck);
                $display("  Got:      cs=%b, mosi=%b, pay=%h, pby=%h, sck=%b",
                         cs, mosi, pay, pby, sck);
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
        $dumpvars(0,clk, miso, cs, mosi, pay, pby, sck);
    end

endmodule
