`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] din;
    reg rd_en;
    reg srst;
    reg wr_en;
    wire [63:0] dout;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rd_en(rd_en),
        .srst(srst),
        .wr_en(wr_en),
        .dout(dout),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            srst = 1;
            wr_en = 0;
            rd_en = 0;
            din = 0;
            @(posedge clk);
            srst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(64'bx, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            wr_en = 1;
            din = 64'hAAAA_BBBB_CCCC_DDDD;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;


            #1;



            check_outputs(64'hAAAA_BBBB_CCCC_DDDD, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Fill FIFO to Full", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                wr_en = 1;
                din = i;
            end
            @(posedge clk);
            wr_en = 0;


            #1;



            check_outputs(64'bx, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Overflow Protection", test_num);
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                wr_en = 1;
                din = i;
            end

            @(posedge clk);
            din = 64'hFFFF_FFFF_FFFF_FFFF;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;


            #1;



            check_outputs(64'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Emptying the FIFO", test_num);
            reset_dut();


            for (i = 1; i <= 5; i = i + 1) begin
                @(posedge clk);
                wr_en = 1;
                din = i * 10;
            end
            @(posedge clk);
            wr_en = 0;


            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
                rd_en = 1;
            end
            @(posedge clk);
            rd_en = 0;


            #1;



            check_outputs(64'd50, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Underflow Protection", test_num);
            reset_dut();


            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            @(posedge clk);
            rd_en = 0;


            #1;



            check_outputs(64'bx, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Pointer Wrap-around", test_num);
            reset_dut();


            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                wr_en = 1; din = i;
            end
            @(posedge clk);
            wr_en = 0;


            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                rd_en = 1;
            end
            @(posedge clk);
            rd_en = 0;


            for (i = 100; i < 110; i = i + 1) begin
                @(posedge clk);
                wr_en = 1; din = i;
            end
            @(posedge clk);
            wr_en = 0;


            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                rd_en = 1;
            end
            @(posedge clk);
            rd_en = 0;


            #1;



            check_outputs(64'd109, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(posedge clk);
            wr_en = 1; din = 64'h1;
            @(posedge clk);
            wr_en = 1; din = 64'h2;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            wr_en = 1; din = 64'h3;
            rd_en = 1;
            @(posedge clk);
            wr_en = 0;
            rd_en = 0;



            #1;




            check_outputs(64'h1, 1'b0, 1'b0);
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
        input [63:0] expected_dout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b",
                         dout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b",
                         expected_dout, expected_empty, expected_full);
                $display("  Got:      dout=%h, empty=%b, full=%b",
                         dout, empty, full);
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
        $dumpvars(0,clk, din, rd_en, srst, wr_en, dout, empty, full);
    end

endmodule
