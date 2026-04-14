`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd;
    reg reset_n;
    reg wr;
    reg [31:0] wr_data;
    wire empty;
    wire full;
    wire [31:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd(rd),
        .reset_n(reset_n),
        .wr(wr),
        .wr_data(wr_data),
        .empty(empty),
        .full(full),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            wr = 0;
            rd = 0;
            wr_data = 0;
            @(posedge clk);
            #1 reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 32'hxxxxxxxx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write", test_num);
            reset_dut();
            wr = 1; wr_data = 32'hAAAA_BBBB;
            @(posedge clk);
            #1 wr = 0;

            #1;


            check_outputs(1'b0, 1'b0, 32'hxxxxxxxx);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Fill FIFO", test_num);
            reset_dut();
            wr = 1; wr_data = 32'h1111_1111; @(posedge clk);
            #1 wr = 1; wr_data = 32'h2222_2222; @(posedge clk);
            #1 wr = 0;

            #1;


            check_outputs(1'b0, 1'b1, 32'hxxxxxxxx);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Read First Item", test_num);
            reset_dut();

            wr = 1; wr_data = 32'hCAFE_BABE; @(posedge clk);
            #1 wr = 1; wr_data = 32'hDEAD_BEEF; @(posedge clk);
            #1 wr = 0;

            rd = 1; @(posedge clk);
            #1 rd = 0;

            #1;


            check_outputs(1'b0, 1'b0, 32'hCAFE_BABE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Read Until Empty", test_num);
            reset_dut();

            wr = 1; wr_data = 32'h1010_1010; @(posedge clk);
            #1 wr = 1; wr_data = 32'h2020_2020; @(posedge clk);
            #1 wr = 0;

            rd = 1; @(posedge clk);
            #1 rd = 1; @(posedge clk);
            #1 rd = 0;

            #1;


            check_outputs(1'b1, 1'b0, 32'h2020_2020);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Overflow Check", test_num);
            reset_dut();

            wr = 1; wr_data = 32'h1; @(posedge clk);
            #1 wr = 1; wr_data = 32'h2; @(posedge clk);

            #1 wr = 1; wr_data = 32'h3; @(posedge clk);
            #1 wr = 0;

            rd = 1; @(posedge clk);
            #1 rd = 0;
            #1;

            check_outputs(1'b0, 1'b0, 32'h0000_0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Pointer Wrap-around", test_num);
            reset_dut();

            wr = 1; wr_data = 32'hA; @(posedge clk);
            #1 wr = 1; wr_data = 32'hB; @(posedge clk);
            #1 wr = 0; rd = 1; @(posedge clk);
            #1 rd = 1; @(posedge clk);
            #1 rd = 0; wr = 1; wr_data = 32'hC; @(posedge clk);
            #1 wr = 0;
            rd = 1; @(posedge clk);
            #1 rd = 0;
            #1;

            check_outputs(1'b1, 1'b0, 32'h0000_000C);
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
        testcase007();
        
        
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
        input expected_empty;
        input expected_full;
        input [31:0] expected_rd_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, rd_data=%h",
                         empty, full, rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, rd_data=%h",
                         expected_empty, expected_full, expected_rd_data);
                $display("  Got:      empty=%b, full=%b, rd_data=%h",
                         empty, full, rd_data);
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
        $dumpvars(0,clk, rd, reset_n, wr, wr_data, empty, full, rd_data);
    end

endmodule
