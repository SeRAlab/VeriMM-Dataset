`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_i;
    reg clk;
    reg [31:0] data_i;
    reg rst;
    reg tx_pop_i;
    reg we_i;
    wire [31:0] data_o;
    wire tx_ack_o;
    wire [23:0] tx_data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_i(addr_i),
        .clk(clk),
        .data_i(data_i),
        .rst(rst),
        .tx_pop_i(tx_pop_i),
        .we_i(we_i),
        .data_o(data_o),
        .tx_ack_o(tx_ack_o),
        .tx_data_o(tx_data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr_i = 0;
            data_i = 0;
            tx_pop_i = 0;
            we_i = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            addr_i = 32'h0;
            data_i = 32'hABCDEF;
            we_i = 1;
            @(posedge clk);
            we_i = 0;
            @(posedge clk);


            tx_pop_i = 1;
            @(posedge clk);
            tx_pop_i = 0;


            #1;



            check_outputs(32'h0, 1'b1, 24'hABCDEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            repeat(3) begin
                addr_i = 32'h0;
                data_i = $random & 32'hFFFFFF;
                we_i = 1;
                @(posedge clk);
            end
            we_i = 0;


            addr_i = 32'h4;
            @(posedge clk);


            #1;



            check_outputs(32'h3, 1'b0, 24'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            addr_i = 32'h0;
            data_i = 32'h111111;
            we_i = 1;
            @(posedge clk);

            data_i = 32'h222222;
            @(posedge clk);
            we_i = 0;


            tx_pop_i = 1;
            @(posedge clk);
            tx_pop_i = 0;

            #1;


            check_outputs(32'h0, 1'b1, 24'h111111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            addr_i = 32'h0;
            data_i = 32'h556677;
            we_i = 1;
            @(posedge clk);
            we_i = 0;


            addr_i = 32'h8;
            @(posedge clk);

            #1;


            check_outputs(32'h556677, 1'b0, 24'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            tx_pop_i = 1;
            @(posedge clk);
            tx_pop_i = 0;
            @(posedge clk);


            #1;



            check_outputs(32'h0, 1'b0, 24'h0);
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
        input [31:0] expected_data_o;
        input expected_tx_ack_o;
        input [23:0] expected_tx_data_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_tx_ack_o === (expected_tx_ack_o ^ tx_ack_o ^ expected_tx_ack_o) &&
                expected_tx_data_o === (expected_tx_data_o ^ tx_data_o ^ expected_tx_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, tx_ack_o=%b, tx_data_o=%h",
                         data_o, tx_ack_o, tx_data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, tx_ack_o=%b, tx_data_o=%h",
                         expected_data_o, expected_tx_ack_o, expected_tx_data_o);
                $display("  Got:      data_o=%h, tx_ack_o=%b, tx_data_o=%h",
                         data_o, tx_ack_o, tx_data_o);
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
        $dumpvars(0,addr_i, clk, data_i, rst, tx_pop_i, we_i, data_o, tx_ack_o, tx_data_o);
    end

endmodule
