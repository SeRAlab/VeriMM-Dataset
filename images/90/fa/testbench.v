`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg [7:0] read_addr;
    reg read_en;
    reg reset;
    reg sel_b1;
    reg sel_b2;
    reg [7:0] write_addr;
    reg [3:0] write_data;
    reg write_en;
    wire [3:0] final_output;
    wire [3:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .read_addr(read_addr),
        .read_en(read_en),
        .reset(reset),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .final_output(final_output),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0; b = 0; sel_b1 = 0; sel_b2 = 0;
            write_en = 0; write_addr = 0; write_data = 0;
            read_en = 0; read_addr = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            a = 4'h3;
            read_en = 1;
            read_addr = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h2, 4'hF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            write_en = 1; write_addr = 8'h10; write_data = 4'h5;
            @(posedge clk);
            #1;
            write_en = 0;


            read_en = 1; read_addr = 8'h10; a = 4'h1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h6, 4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();


            a = 4'hA; b = 4'h4;
            sel_b1 = 1; sel_b2 = 0;
            read_en = 1; read_addr = 8'h05;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3, 4'hF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();


            a = 4'h2; b = 4'h7;
            sel_b1 = 0; sel_b2 = 1;
            read_en = 1; read_addr = 8'h20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h6, 4'hF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();



            write_en = 1; write_addr = 8'hFF; write_data = 4'h1;
            @(posedge clk);
            #1 write_en = 0;
            a = 4'hA; b = 4'h6;
            sel_b1 = 1; sel_b2 = 1;
            read_en = 1; read_addr = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF, 4'h1);
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
        input [3:0] expected_final_output;
        input [3:0] expected_read_data;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, read_data=%h",
                         final_output, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, read_data=%h",
                         expected_final_output, expected_read_data);
                $display("  Got:      final_output=%h, read_data=%h",
                         final_output, read_data);
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
        $dumpvars(0,a, b, clk, read_addr, read_en, reset, sel_b1, sel_b2, write_addr, write_data, write_en, final_output, read_data);
    end

endmodule
