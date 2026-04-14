`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] read_addr;
    reg read_en;
    reg rst_n;
    reg [7:0] write_addr;
    reg [3:0] write_data;
    reg write_en;
    wire [7:0] final_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_addr(read_addr),
        .read_en(read_en),
        .rst_n(rst_n),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .final_output(final_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            write_en = 0;
            read_en = 0;
            write_addr = 0;
            read_addr = 0;
            write_data = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            write_en = 1;
            write_addr = 8'h00;
            write_data = 4'hA;
            @(posedge clk);


            write_en = 0;
            read_en = 1;
            read_addr = 8'h00;
            @(posedge clk);


            #1;



            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            write_en = 1; write_addr = 8'h00; write_data = 4'h1;
            @(posedge clk);


            write_en = 1; write_addr = 8'h01; write_data = 4'h2;
            @(posedge clk);


            write_en = 0; read_en = 1; read_addr = 8'h00;
            @(posedge clk);


            #1;



            check_outputs(8'h21);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            write_en = 1; write_addr = 8'h08; write_data = 4'hB;
            @(posedge clk);


            write_en = 0; read_en = 1; read_addr = 8'h10;
            @(posedge clk);


            #1;



            check_outputs(8'hBB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            write_en = 1; write_addr = 8'h02; write_data = 4'h5;
            @(posedge clk);


            write_en = 0; write_addr = 8'h02; write_data = 4'hF;
            @(posedge clk);


            read_en = 1; read_addr = 8'h02;
            @(posedge clk);




            #1;





            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            write_en = 1; write_addr = 8'h02; write_data = 4'h7;
            @(posedge clk);


            write_en = 1; write_addr = 8'h03; write_data = 4'h9;
            read_en = 1; read_addr = 8'h02;
            @(posedge clk);




            #1;





            check_outputs(8'h97);
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
        input [7:0] expected_final_output;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h",
                         final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h",
                         expected_final_output);
                $display("  Got:      final_output=%h",
                         final_output);
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
        $dumpvars(0,clk, read_addr, read_en, rst_n, write_addr, write_data, write_en, final_output);
    end

endmodule
