`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg [7:0] read_addr;
    reg read_en;
    reg rst_n;
    reg [7:0] write_addr;
    reg [3:0] write_data;
    reg write_en;
    wire out_and_alwaysblock;
    wire out_and_assign;
    wire [7:0] ram_and_and_output;
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
        .rst_n(rst_n),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .out_and_alwaysblock(out_and_alwaysblock),
        .out_and_assign(out_and_assign),
        .ram_and_and_output(ram_and_and_output),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            a = 0;
            b = 0;
            write_en = 0;
            write_addr = 0;
            write_data = 0;
            read_en = 0;
            read_addr = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verifying AND logic and basic reset state", test_num);
            reset_dut();


            a = 1;
            b = 1;


            @(posedge clk);
            #2;



            #1;




            check_outputs(1'b1, 1'b1, 8'h01, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single RAM Write and Read back", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 8'h03;
            write_data = 4'hA;
            @(posedge clk);
            write_en = 0;


            read_en = 1;
            read_addr = 8'h03;
            @(posedge clk);
            #2;



            #1;




            check_outputs(1'b0, 1'b0, 8'h0A, 4'hA);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: RAM Summation with AND=0", test_num);
            reset_dut();


            write_en = 1;
            for(i=0; i<8; i=i+1) begin
                write_addr = i;
                write_data = 4'h1;
                @(posedge clk);
            end
            write_en = 0;


            read_en = 1;
            read_addr = 8'h00;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0, 8'h08, 4'h1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: RAM Summation with AND=1 (Incremental value)", test_num);
            reset_dut();


            a = 1;
            b = 1;


            write_en = 1;
            for(i=0; i<8; i=i+1) begin
                write_addr = i;
                write_data = 4'h2;
                @(posedge clk);
            end
            write_en = 0;


            read_en = 1;
            read_addr = 8'h07;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b1, 8'h11, 4'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: RAM address alias/wraparound check", test_num);
            reset_dut();


            write_en = 1;
            write_addr = 8'h00;
            write_data = 4'h5;
            @(posedge clk);


            write_addr = 8'h08;
            write_data = 4'hF;
            @(posedge clk);
            write_en = 0;


            read_en = 1;
            read_addr = 8'h00;
            @(posedge clk);
            #2;



            #1;




            check_outputs(1'b0, 1'b0, 8'h0F, 4'hF);
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
        input expected_out_and_alwaysblock;
        input expected_out_and_assign;
        input [7:0] expected_ram_and_and_output;
        input [3:0] expected_read_data;
        begin
            if (expected_out_and_alwaysblock === (expected_out_and_alwaysblock ^ out_and_alwaysblock ^ expected_out_and_alwaysblock) &&
                expected_out_and_assign === (expected_out_and_assign ^ out_and_assign ^ expected_out_and_assign) &&
                expected_ram_and_and_output === (expected_ram_and_and_output ^ ram_and_and_output ^ expected_ram_and_and_output) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: out_and_alwaysblock=%b, out_and_assign=%b, ram_and_and_output=%h, read_data=%h",
                         out_and_alwaysblock, out_and_assign, ram_and_and_output, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and_alwaysblock=%b, out_and_assign=%b, ram_and_and_output=%h, read_data=%h",
                         expected_out_and_alwaysblock, expected_out_and_assign, expected_ram_and_and_output, expected_read_data);
                $display("  Got:      out_and_alwaysblock=%b, out_and_assign=%b, ram_and_and_output=%h, read_data=%h",
                         out_and_alwaysblock, out_and_assign, ram_and_and_output, read_data);
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
        $dumpvars(0,a, b, clk, read_addr, read_en, rst_n, write_addr, write_data, write_en, out_and_alwaysblock, out_and_assign, ram_and_and_output, read_data);
    end

endmodule
