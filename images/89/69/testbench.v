`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd;
    reg reset_n;
    reg wr;
    reg [31:0] wr_data;
    wire almost_empty;
    wire almost_full;
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
        .almost_empty(almost_empty),
        .almost_full(almost_full),
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
            #1;
            reset_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(1, 0, 1, 0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Write", test_num);
            reset_dut();

            wr = 1;
            wr_data = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            wr = 0;





            #1;






            check_outputs(1, 1, 0, 0, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Fill to Full", test_num);
            reset_dut();


            wr = 1; wr_data = 32'h11111111;
            @(posedge clk);
            #1;

            wr_data = 32'h22222222;
            @(posedge clk);
            #1;
            wr = 0;


            #1;



            check_outputs(0, 1, 0, 1, 32'h11111111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Write 2 then Read 1", test_num);
            reset_dut();


            wr = 1; wr_data = 32'hAAAA_AAAA; @(posedge clk); #1;
            wr = 1; wr_data = 32'hBBBB_BBBB; @(posedge clk); #1;
            wr = 0;


            rd = 1;
            @(posedge clk);
            #1;
            rd = 0;



            #1;




            check_outputs(1, 1, 0, 0, 32'hBBBB_BBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Fill and Empty", test_num);
            reset_dut();


            wr = 1; wr_data = 32'h1; @(posedge clk); #1;
            wr = 1; wr_data = 32'h2; @(posedge clk); #1;
            wr = 0;


            rd = 1; @(posedge clk); #1;
            rd = 1; @(posedge clk); #1;
            rd = 0;


            #1;



            check_outputs(1, 0, 1, 0, 32'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Overflow", test_num);
            reset_dut();

            wr = 1; wr_data = 32'hD1; @(posedge clk); #1;
            wr = 1; wr_data = 32'hD2; @(posedge clk); #1;
            wr = 1; wr_data = 32'hD3; @(posedge clk); #1;
            wr = 0;


            #1;



            check_outputs(0, 1, 0, 1, 32'hD1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Underflow", test_num);
            reset_dut();

            rd = 1;
            @(posedge clk);
            #1;
            rd = 0;


            #1;



            check_outputs(1, 0, 1, 0, 32'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Simultaneous R/W", test_num);
            reset_dut();


            wr = 1; wr_data = 32'hFACE_FEED;
            @(posedge clk);
            #1;


            wr = 1; wr_data = 32'hCAFE_BABE;
            rd = 1;
            @(posedge clk);
            #1;
            wr = 0;
            rd = 0;



            #1;




            check_outputs(1, 1, 0, 0, 32'hCAFE_BABE);
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
        testcase008();
        
        
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
        input expected_almost_empty;
        input expected_almost_full;
        input expected_empty;
        input expected_full;
        input [31:0] expected_rd_data;
        begin
            if (expected_almost_empty === (expected_almost_empty ^ almost_empty ^ expected_almost_empty) &&
                expected_almost_full === (expected_almost_full ^ almost_full ^ expected_almost_full) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: almost_empty=%b, almost_full=%b, empty=%b, full=%b, rd_data=%h",
                         almost_empty, almost_full, empty, full, rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: almost_empty=%b, almost_full=%b, empty=%b, full=%b, rd_data=%h",
                         expected_almost_empty, expected_almost_full, expected_empty, expected_full, expected_rd_data);
                $display("  Got:      almost_empty=%b, almost_full=%b, empty=%b, full=%b, rd_data=%h",
                         almost_empty, almost_full, empty, full, rd_data);
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
        $dumpvars(0,clk, rd, reset_n, wr, wr_data, almost_empty, almost_full, empty, full, rd_data);
    end

endmodule
