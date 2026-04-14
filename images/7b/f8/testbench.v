`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] reg_addr;
    reg reg_rd_wr_L;
    reg reg_req;
    reg [31:0] reg_wr_data;
    reg reset;
    wire reg_ack;
    wire [31:0] reg_rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reg_addr(reg_addr),
        .reg_rd_wr_L(reg_rd_wr_L),
        .reg_req(reg_req),
        .reg_wr_data(reg_wr_data),
        .reset(reset),
        .reg_ack(reg_ack),
        .reg_rd_data(reg_rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            reg_req = 0;
            reg_rd_wr_L = 0;
            reg_addr = 0;
            reg_wr_data = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (Addr 0x05)", test_num);
            reset_dut();


            reg_req = 1;
            reg_rd_wr_L = 0;
            reg_addr = 8'h05;
            reg_wr_data = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            reg_req = 0;
            @(posedge clk);
            #1;


            reg_req = 1;
            reg_rd_wr_L = 1;
            reg_addr = 8'h05;
            @(posedge clk);
            #1;
            reg_req = 0;

            #1;


            check_outputs(1'b1, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address (Addr 0xFF)", test_num);
            reset_dut();


            reg_req = 1;
            reg_rd_wr_L = 0;
            reg_addr = 8'hFF;
            reg_wr_data = 32'hCAFE_BABE;
            @(posedge clk);
            #1;
            reg_req = 0;
            @(posedge clk);
            #1;


            reg_req = 1;
            reg_rd_wr_L = 1;
            reg_addr = 8'hFF;
            @(posedge clk);
            #1;
            reg_req = 0;

            #1;


            check_outputs(1'b1, 32'hCAFE_BABE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Verification (Addr 0x10)", test_num);
            reset_dut();


            reg_req = 1;
            reg_rd_wr_L = 0;
            reg_addr = 8'h10;
            reg_wr_data = 32'h1111_1111;
            @(posedge clk);
            #1;


            reg_wr_data = 32'h2222_2222;
            @(posedge clk);
            #1;
            reg_req = 0;
            @(posedge clk);
            #1;


            reg_req = 1;
            reg_rd_wr_L = 1;
            reg_addr = 8'h10;
            @(posedge clk);
            #1;
            reg_req = 0;

            #1;


            check_outputs(1'b1, 32'h2222_2222);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-Register Sequence", test_num);
            reset_dut();


            reg_req = 1; reg_rd_wr_L = 0; reg_addr = 8'h20; reg_wr_data = 32'hAAAA_AAAA;
            @(posedge clk);
            #1;

            reg_addr = 8'h21; reg_wr_data = 32'hBBBB_BBBB;
            @(posedge clk);
            #1;
            reg_req = 0;
            @(posedge clk);
            #1;


            reg_req = 1; reg_rd_wr_L = 1; reg_addr = 8'h20;
            @(posedge clk);
            #1;

            reg_addr = 8'h21;
            @(posedge clk);
            #1;
            reg_req = 0;

            #1;


            check_outputs(1'b1, 32'hBBBB_BBBB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No Request Interaction", test_num);
            reset_dut();


            reg_req = 0;
            reg_rd_wr_L = 0;
            reg_addr = 8'h30;
            reg_wr_data = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;


            reg_req = 1;
            reg_rd_wr_L = 1;
            reg_addr = 8'h30;
            @(posedge clk);
            #1;
            reg_req = 0;


            #1;



            check_outputs(1'b1, 32'h0000_0000);
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
        input expected_reg_ack;
        input [31:0] expected_reg_rd_data;
        begin
            if (expected_reg_ack === (expected_reg_ack ^ reg_ack ^ expected_reg_ack) &&
                expected_reg_rd_data === (expected_reg_rd_data ^ reg_rd_data ^ expected_reg_rd_data)) begin
                $display("PASS");
                $display("  Outputs: reg_ack=%b, reg_rd_data=%h",
                         reg_ack, reg_rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_ack=%b, reg_rd_data=%h",
                         expected_reg_ack, expected_reg_rd_data);
                $display("  Got:      reg_ack=%b, reg_rd_data=%h",
                         reg_ack, reg_rd_data);
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
        $dumpvars(0,clk, reg_addr, reg_rd_wr_L, reg_req, reg_wr_data, reset, reg_ack, reg_rd_data);
    end

endmodule
