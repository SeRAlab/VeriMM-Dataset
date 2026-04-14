`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg WEBWE;
    reg [8:0] count_d1_reg;
    reg [8:0] count_d2_reg;
    reg [31:0] din;
    reg rd_clk;
    reg tmp_ram_rd_en;
    reg wr_clk;
    wire Q;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .WEBWE(WEBWE),
        .count_d1_reg(count_d1_reg),
        .count_d2_reg(count_d2_reg),
        .din(din),
        .rd_clk(rd_clk),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .wr_clk(wr_clk),
        .Q(Q),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

        begin
            WEBWE = 0;
            din = 0;
            tmp_ram_rd_en = 0;
            count_d1_reg = 0;
            count_d2_reg = 0;
            repeat(5) @(posedge wr_clk);
            repeat(5) @(posedge rd_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: Basic Single Write/Read", test_num);
            reset_dut();


            @(posedge wr_clk);
            WEBWE = 1;
            din = 32'hA5A5A5A5;
            count_d1_reg = 1;
            @(posedge wr_clk);
            WEBWE = 0;


            repeat(2) @(posedge rd_clk);
            tmp_ram_rd_en = 1;
            count_d2_reg = 1;
            @(posedge rd_clk);
            tmp_ram_rd_en = 0;

            #1;
            #1;

            check_outputs(1'b0, 32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: Multiple Writes and Reads", test_num);
            reset_dut();


            @(posedge wr_clk);
            WEBWE = 1; din = 32'h11111111; count_d1_reg = 1;
            @(posedge wr_clk);

            WEBWE = 1; din = 32'h22222222; count_d1_reg = 2;
            @(posedge wr_clk);
            WEBWE = 0;


            repeat(2) @(posedge rd_clk);
            tmp_ram_rd_en = 1; count_d2_reg = 1;
            @(posedge rd_clk);

            tmp_ram_rd_en = 1; count_d2_reg = 2;
            @(posedge rd_clk);
            tmp_ram_rd_en = 0;

            #1;
            #1;

            check_outputs(1'b0, 32'h22222222);
        end
    endcase


    task testcase003;
        begin
            test_num = 3;
            $display("Running Testcase %0d: Check Status Flag Q", test_num);
            reset_dut();


            @(posedge wr_clk);
            WEBWE = 1;
            din = 32'hBEEFCAFE;
            count_d1_reg = 1;
            @(posedge wr_clk);
            WEBWE = 0;

            repeat(2) @(posedge rd_clk);
            #1;
            #1;

            check_outputs(1'b1, dout);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %0d: Empty Read Check", test_num);
            reset_dut();


            @(posedge rd_clk);
            tmp_ram_rd_en = 1;
            count_d2_reg = 1;
            @(posedge rd_clk);
            tmp_ram_rd_en = 0;

            #1;
            #1;

            check_outputs(1'b0, dout);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %0d: Data Persistence", test_num);
            reset_dut();


            @(posedge wr_clk);
            WEBWE = 1; din = 32'h12345678; count_d1_reg = 1;
            @(posedge wr_clk);
            WEBWE = 0;


            repeat(10) @(posedge rd_clk);


            tmp_ram_rd_en = 1; count_d2_reg = 1;
            @(posedge rd_clk);
            tmp_ram_rd_en = 0;

            #1;
            #1;

            check_outputs(1'b0, 32'h12345678);
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
        input expected_Q;
        input [31:0] expected_dout;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, dout=%h",
                         Q, dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, dout=%h",
                         expected_Q, expected_dout);
                $display("  Got:      Q=%b, dout=%h",
                         Q, dout);
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
        $dumpvars(0,WEBWE, count_d1_reg, count_d2_reg, din, rd_clk, tmp_ram_rd_en, wr_clk, Q, dout);
    end

endmodule
