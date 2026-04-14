`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] bpldata;
    reg clk;
    reg [15:0] data_in;
    reg dblpf;
    reg [7:0] nsprite;
    reg [7:0] reg_address_in;
    reg reset;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bpldata(bpldata),
        .clk(clk),
        .data_in(data_in),
        .dblpf(dblpf),
        .nsprite(nsprite),
        .reg_address_in(reg_address_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            bpldata = 0;
            data_in = 0;
            dblpf = 0;
            nsprite = 0;
            reg_address_in = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            reg_address_in = 8'h07;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            reg_address_in = 8'h07;


            @(posedge clk);
            nsprite = 8'b00000011;
            @(posedge clk);
            nsprite = 0;


            #1;



            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            reg_address_in = 8'h07;


            @(posedge clk);
            nsprite = 8'b00000001;
            bpldata = 6'b000001;
            @(posedge clk);
            nsprite = 0;
            bpldata = 0;



            if (data_out != 16'h0000) begin
                $display("PASS: Collision Detected (data_out=%h)", data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: No Sprite-PF collision detected");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            reg_address_in = 8'h07;


            @(posedge clk);
            nsprite = 8'b00001100;
            @(posedge clk);
            nsprite = 0;


            repeat(5) @(posedge clk);


            if (data_out & 16'h0002) begin
                 $display("PASS: Collision Latched");
                 pass_count = pass_count + 1;
            end else begin
                 $display("FAIL: Collision not latched");
                 fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            reg_address_in = 8'h07;
            dblpf = 1;


            @(posedge clk);
            nsprite = 8'b00010000;
            bpldata = 6'b000010;
            @(posedge clk);
            nsprite = 0;
            bpldata = 0;

            if (data_out != 16'h0000) begin
                $display("PASS: DPF Collision Detected (%h)", data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: DPF Collision missed");
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,bpldata, clk, data_in, dblpf, nsprite, reg_address_in, reset, data_out);
    end

endmodule
