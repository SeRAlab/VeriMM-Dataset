`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clk;
    reg [31:0] data_in;
    reg read_en;
    reg reset;
    reg write_en;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .read_en(read_en),
        .reset(reset),
        .write_en(write_en),
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
            read_en = 0;
            write_en = 0;
            address = 0;
            data_in = 0;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read (Addr 0)", test_num);
            reset_dut();


            address = 32'h0000_0000;
            data_in = 32'hDEADBEEF;
            write_en = 1;
            @(posedge clk);
            write_en = 0;
            repeat(10) @(posedge clk);


            address = 32'h0000_0000;
            read_en = 1;
            @(posedge clk);
            read_en = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Address Write/Read (Addr 1023)", test_num);
            reset_dut();


            address = 32'd1023;
            data_in = 32'hAAAA_5555;
            write_en = 1;
            @(posedge clk);
            write_en = 0;
            repeat(10) @(posedge clk);


            address = 32'd1023;
            read_en = 1;
            @(posedge clk);
            read_en = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(32'hAAAA_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwrite Data", test_num);
            reset_dut();


            address = 32'h0000_0010;
            data_in = 32'h1111_1111;
            write_en = 1;
            @(posedge clk);
            write_en = 0;
            repeat(10) @(posedge clk);


            data_in = 32'h2222_2222;
            write_en = 1;
            @(posedge clk);
            write_en = 0;
            repeat(10) @(posedge clk);


            read_en = 1;
            @(posedge clk);
            read_en = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Address Writes", test_num);
            reset_dut();


            address = 32'd5;
            data_in = 32'h0000_0005;
            write_en = 1;
            @(posedge clk);
            write_en = 0;
            repeat(10) @(posedge clk);


            address = 32'd50;
            data_in = 32'h0000_0032;
            write_en = 1;
            @(posedge clk);
            write_en = 0;
            repeat(10) @(posedge clk);


            address = 32'd5;
            read_en = 1;
            @(posedge clk);
            read_en = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(32'h0000_0005);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Persistence during sequence", test_num);
            reset_dut();


            address = 32'd100;
            data_in = 32'hCAFE_BABE;
            write_en = 1;
            @(posedge clk);
            write_en = 0;
            repeat(10) @(posedge clk);


            address = 32'd200;
            read_en = 1;
            @(posedge clk);
            read_en = 0;
            repeat(10) @(posedge clk);


            address = 32'd100;
            read_en = 1;
            @(posedge clk);
            read_en = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(32'hCAFE_BABE);
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,address, clk, data_in, read_en, reset, write_en, data_out);
    end

endmodule
