`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [3:0] read_addr;
    reg read_en;
    reg reset;
    reg [3:0] write_addr;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .read_addr(read_addr),
        .read_en(read_en),
        .reset(reset),
        .write_addr(write_addr),
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
            data_in = 0;
            write_addr = 0;
            read_addr = 0;
            write_en = 0;
            read_en = 0;
            #15;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            read_addr = 4'h5;
            read_en = 1;
            @(posedge clk);
            #2;

            $display("Testcase %0d: Reset verification (Read addr 5)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge clk);
            write_addr = 4'h3;
            data_in = 8'hAA;
            write_en = 1;
            @(posedge clk);
            write_en = 0;


            read_addr = 4'h3;
            read_en = 1;
            @(posedge clk);
            #2;

            $display("Testcase %0d: Basic Write/Read (Write 0xAA to addr 3)", test_num);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(posedge clk);
            write_addr = 4'h7;
            data_in = 8'hFF;
            write_en = 0;
            @(posedge clk);


            read_addr = 4'h7;
            read_en = 1;
            @(posedge clk);
            #2;

            $display("Testcase %0d: Write Enable Check (Write 0xFF with en=0)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(posedge clk);
            write_addr = 4'hA;
            data_in = 8'h11;
            write_en = 1;
            @(posedge clk);


            data_in = 8'h22;
            @(posedge clk);
            write_en = 0;


            read_addr = 4'hA;
            read_en = 1;
            @(posedge clk);
            #2;

            $display("Testcase %0d: Overwrite Check (Write 0x11 then 0x22 to addr A)", test_num);
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(posedge clk);
            write_addr = 4'h1;
            data_in = 8'h55;
            write_en = 1;
            @(posedge clk);


            write_addr = 4'h2;
            data_in = 8'h66;
            write_en = 1;
            @(posedge clk);
            write_en = 0;


            read_addr = 4'h1;
            read_en = 1;
            @(posedge clk);


            read_addr = 4'h2;
            @(posedge clk);
            #2;

            $display("Testcase %0d: Multiple Registers (Reading addr 2 after sequence)", test_num);
            #1;

            check_outputs(8'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            @(posedge clk);
            write_addr = 4'h4;
            data_in = 8'hCC;
            write_en = 1;
            @(posedge clk);
            write_en = 0;


            read_en = 0;
            read_addr = 4'h4;
            @(posedge clk);
            #2;




            $display("Testcase %0d: Read Enable Check (Read addr 4 with read_en=0)", test_num);
            #1;

            check_outputs(8'h00);
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
        testcase006();
        
        
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, read_addr, read_en, reset, write_addr, write_en, data_out);
    end

endmodule
