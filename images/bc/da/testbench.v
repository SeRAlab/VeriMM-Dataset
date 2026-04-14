`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dout;
    reg reset;
    reg rx_done_tick;
    wire gotten_code_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dout(dout),
        .reset(reset),
        .rx_done_tick(rx_done_tick),
        .gotten_code_flag(gotten_code_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            rx_done_tick = 0;
            dout = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task send_byte;

        input [7:0] byte_data;
        begin
            @(posedge clk);
            #1;
            dout = byte_data;
            rx_done_tick = 1;
            @(posedge clk);
            #1;
            rx_done_tick = 0;
            dout = 8'h00;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard sequence (F0 -> 1C)", test_num);
            reset_dut();

            send_byte(8'hF0);
            send_byte(8'h1C);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key code without F0", test_num);
            reset_dut();

            send_byte(8'h1C);
            send_byte(8'h1C);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random bytes before valid sequence", test_num);
            reset_dut();

            send_byte(8'hAA);
            send_byte(8'h55);
            send_byte(8'hF0);
            send_byte(8'h2D);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset mid-sequence", test_num);
            reset_dut();

            send_byte(8'hF0);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;

            send_byte(8'h1C);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Consecutive F0 bytes", test_num);
            reset_dut();

            send_byte(8'hF0);
            send_byte(8'hF0);

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
        input expected_gotten_code_flag;
        begin
            if (expected_gotten_code_flag === (expected_gotten_code_flag ^ gotten_code_flag ^ expected_gotten_code_flag)) begin
                $display("PASS");
                $display("  Outputs: gotten_code_flag=%b",
                         gotten_code_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gotten_code_flag=%b",
                         expected_gotten_code_flag);
                $display("  Got:      gotten_code_flag=%b",
                         gotten_code_flag);
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
        $dumpvars(0,clk, dout, reset, rx_done_tick, gotten_code_flag);
    end

endmodule
