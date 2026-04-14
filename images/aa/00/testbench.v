`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] addr_i;
    reg clk_i;
    reg rst_i;
    reg valid_i;
    reg w_r_data_i;
    reg [15:0] wdata_i;
    wire [15:0] rdata_o;
    wire ready_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_i(addr_i),
        .clk_i(clk_i),
        .rst_i(rst_i),
        .valid_i(valid_i),
        .w_r_data_i(w_r_data_i),
        .wdata_i(wdata_i),
        .rdata_o(rdata_o),
        .ready_o(ready_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            addr_i = 0;
            wdata_i = 0;
            w_r_data_i = 0;
            valid_i = 0;
            @(posedge clk_i);
            #1 rst_i = 0;
            @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial Reset State Check...");
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Write and Read...");
            reset_dut();


            @(posedge clk_i);
            addr_i = 6'h05;
            wdata_i = 16'hABCD;
            w_r_data_i = 1'b1;
            valid_i = 1'b1;

            @(posedge clk_i);

            addr_i = 6'h05;
            w_r_data_i = 1'b0;
            valid_i = 1'b1;

            @(posedge clk_i);

            #1;


            check_outputs(16'hABCD, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write/Read at Max Address (63)...");
            reset_dut();


            @(posedge clk_i);
            addr_i = 6'd63;
            wdata_i = 16'hFFFF;
            w_r_data_i = 1'b1;
            valid_i = 1'b1;

            @(posedge clk_i);

            addr_i = 6'd63;
            w_r_data_i = 1'b0;

            @(posedge clk_i);
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Verify Write is ignored when valid_i is low...");
            reset_dut();


            @(posedge clk_i);
            addr_i = 6'h10;
            wdata_i = 16'h5555;
            w_r_data_i = 1'b1;
            valid_i = 1'b0;

            @(posedge clk_i);

            addr_i = 6'h10;
            w_r_data_i = 1'b0;
            valid_i = 1'b1;

            @(posedge clk_i);

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwriting data at the same address...");
            reset_dut();


            @(posedge clk_i);
            addr_i = 6'h20;
            wdata_i = 16'h1111;
            w_r_data_i = 1'b1;
            valid_i = 1'b1;

            @(posedge clk_i);

            wdata_i = 16'h2222;

            @(posedge clk_i);

            w_r_data_i = 1'b0;

            @(posedge clk_i);
            #1;

            check_outputs(16'h2222, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Verify Reset clears memory contents...");
            reset_dut();


            @(posedge clk_i);
            addr_i = 6'h0A;
            wdata_i = 16'hDEAD;
            w_r_data_i = 1'b1;
            valid_i = 1'b1;

            @(posedge clk_i);

            rst_i = 1'b1;
            @(posedge clk_i);
            rst_i = 1'b0;


            @(posedge clk_i);
            addr_i = 6'h0A;
            w_r_data_i = 1'b0;
            valid_i = 1'b1;

            @(posedge clk_i);

            #1;


            check_outputs(16'h0000, 1'b1);
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
        input [15:0] expected_rdata_o;
        input expected_ready_o;
        begin
            if (expected_rdata_o === (expected_rdata_o ^ rdata_o ^ expected_rdata_o) &&
                expected_ready_o === (expected_ready_o ^ ready_o ^ expected_ready_o)) begin
                $display("PASS");
                $display("  Outputs: rdata_o=%h, ready_o=%b",
                         rdata_o, ready_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata_o=%h, ready_o=%b",
                         expected_rdata_o, expected_ready_o);
                $display("  Got:      rdata_o=%h, ready_o=%b",
                         rdata_o, ready_o);
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
        $dumpvars(0,addr_i, clk_i, rst_i, valid_i, w_r_data_i, wdata_i, rdata_o, ready_o);
    end

endmodule
