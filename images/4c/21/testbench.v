`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [3:0] rd_addr;
    reg read;
    reg reset;
    reg [3:0] wr_addr;
    reg write;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rd_addr(rd_addr),
        .read(read),
        .reset(reset),
        .wr_addr(wr_addr),
        .write(write),
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
            write = 0;
            read = 0;
            data_in = 0;
            wr_addr = 0;
            rd_addr = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Post-reset zero check", test_num);
            reset_dut();

            read = 1;
            rd_addr = 4'h5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write 0xAA to address 0x3 and read back", test_num);
            reset_dut();


            @(posedge clk);
            write = 1;
            wr_addr = 4'h3;
            data_in = 8'hAA;
            @(posedge clk);
            write = 0;


            read = 1;
            rd_addr = 4'h3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiple writes, single read", test_num);
            reset_dut();

            @(posedge clk);
            write = 1;
            wr_addr = 4'h0; data_in = 8'h11;
            @(posedge clk);
            wr_addr = 4'h8; data_in = 8'h88;
            @(posedge clk);
            wr_addr = 4'hF; data_in = 8'hFF;
            @(posedge clk);
            write = 0;


            read = 1;
            rd_addr = 4'h8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h88);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Overwrite memory location", test_num);
            reset_dut();


            @(posedge clk);
            write = 1;
            wr_addr = 4'hA;
            data_in = 8'h55;
            @(posedge clk);

            data_in = 8'h66;
            @(posedge clk);
            write = 0;

            read = 1;
            rd_addr = 4'hA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h66);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Simultaneous read and write", test_num);
            reset_dut();


            @(posedge clk);
            write = 1;
            wr_addr = 4'h1;
            data_in = 8'hB1;
            @(posedge clk);
            write = 0;


            @(posedge clk);
            read = 1;
            rd_addr = 4'h1;
            write = 1;
            wr_addr = 4'h2;
            data_in = 8'hB2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hB1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Read enable de-asserted", test_num);
            reset_dut();


            @(posedge clk);
            write = 1;
            wr_addr = 4'h7;
            data_in = 8'h77;
            @(posedge clk);
            write = 0;


            read = 0;
            rd_addr = 4'h7;
            @(posedge clk);
            #2;



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
        $dumpvars(0,clk, data_in, rd_addr, read, reset, wr_addr, write, data_out);
    end

endmodule
