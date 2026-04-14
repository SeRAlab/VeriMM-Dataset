`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] din;
    reg rd_clk;
    reg tmp_ram_rd_en;
    reg wr_clk;
    wire E;
    wire Q;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .rd_clk(rd_clk),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .wr_clk(wr_clk),
        .E(E),
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
            din = 0;
            tmp_ram_rd_en = 0;
            wr_clk = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            din = 32'hDEADBEEF;
            #10;
            wr_clk = 1; #10; wr_clk = 0;
            #10;


            @(posedge rd_clk);
            tmp_ram_rd_en = 1;
            @(posedge rd_clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0, 32'hDEADBEEF);
            tmp_ram_rd_en = 0;
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            reset_dut();


            for (i = 0; i < 8192; i = i + 1) begin
                din = i;
                #5 wr_clk = 1; #5 wr_clk = 0;
            end

            #20;

            #1;


            check_outputs(1'b0, 1'b1, dout);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();


            for (i = 0; i < 10; i = i + 1) begin
                din = i + 100;
                #5 wr_clk = 1; #5 wr_clk = 0;
            end


            @(posedge rd_clk);
            tmp_ram_rd_en = 1;
            repeat(10) @(posedge rd_clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b0, 32'd109);
            tmp_ram_rd_en = 0;
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();


            for (i = 0; i < 4096; i = i + 1) begin
                din = i;
                #5 wr_clk = 1; #5 wr_clk = 0;
            end


            @(posedge rd_clk);
            tmp_ram_rd_en = 1;
            repeat(2048) @(posedge rd_clk);
            #2 tmp_ram_rd_en = 0;


            for (i = 0; i < 6000; i = i + 1) begin
                din = i + 5000;
                #5 wr_clk = 1; #5 wr_clk = 0;
            end



            #20;
            #1;

            check_outputs(1'b0, 1'b0, dout);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            din = 32'hAAAA_AAAA;
            #5 wr_clk = 1; #5 wr_clk = 0;


            fork
                begin : write_process
                    din = 32'hBBBB_BBBB;
                    #15 wr_clk = 1; #10 wr_clk = 0;
                end
                begin : read_process
                    @(posedge rd_clk);
                    tmp_ram_rd_en = 1;
                    @(posedge rd_clk);
                    @(posedge rd_clk);
                    #2 tmp_ram_rd_en = 0;
                end
            join

            #20;

            #1;


            check_outputs(1'b1, 1'b0, 32'hBBBB_BBBB);
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
        input expected_E;
        input expected_Q;
        input [31:0] expected_dout;
        begin
            if (expected_E === (expected_E ^ E ^ expected_E) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: E=%b, Q=%b, dout=%h",
                         E, Q, dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: E=%b, Q=%b, dout=%h",
                         expected_E, expected_Q, expected_dout);
                $display("  Got:      E=%b, Q=%b, dout=%h",
                         E, Q, dout);
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
        $dumpvars(0,din, rd_clk, tmp_ram_rd_en, wr_clk, E, Q, dout);
    end

endmodule
