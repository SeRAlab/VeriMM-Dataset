`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] i_tl_cfg_add;
    reg [31:0] i_tl_cfg_ctl;
    reg i_tl_cfg_ctl_wr;
    reg [52:0] i_tl_cfg_sts;
    reg i_tl_cfg_sts_wr;
    reg srst;
    wire [3:0] o_tl_cfg_add;
    wire [31:0] o_tl_cfg_ctl;
    wire o_tl_cfg_ctl_wr;
    wire [52:0] o_tl_cfg_sts;
    wire o_tl_cfg_sts_wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_tl_cfg_add(i_tl_cfg_add),
        .i_tl_cfg_ctl(i_tl_cfg_ctl),
        .i_tl_cfg_ctl_wr(i_tl_cfg_ctl_wr),
        .i_tl_cfg_sts(i_tl_cfg_sts),
        .i_tl_cfg_sts_wr(i_tl_cfg_sts_wr),
        .srst(srst),
        .o_tl_cfg_add(o_tl_cfg_add),
        .o_tl_cfg_ctl(o_tl_cfg_ctl),
        .o_tl_cfg_ctl_wr(o_tl_cfg_ctl_wr),
        .o_tl_cfg_sts(o_tl_cfg_sts),
        .o_tl_cfg_sts_wr(o_tl_cfg_sts_wr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            srst = 1;
            i_tl_cfg_add = 0;
            i_tl_cfg_ctl = 0;
            i_tl_cfg_ctl_wr = 0;
            i_tl_cfg_sts = 0;
            i_tl_cfg_sts_wr = 0;
            @(posedge clk);
            #1;
            srst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 32'h0, 1'b0, 53'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Control Data Write Propagation", test_num);
            reset_dut();

            i_tl_cfg_add = 4'hA;
            i_tl_cfg_ctl = 32'hDEADBEEF;
            i_tl_cfg_ctl_wr = 1'b1;
            i_tl_cfg_sts = 53'h0;
            i_tl_cfg_sts_wr = 1'b0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA, 32'hDEADBEEF, 1'b1, 53'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Status Data Write Propagation", test_num);
            reset_dut();

            i_tl_cfg_add = 4'h5;
            i_tl_cfg_ctl = 32'h0;
            i_tl_cfg_ctl_wr = 1'b0;
            i_tl_cfg_sts = 53'h1FFFFFFFFFFFFF;
            i_tl_cfg_sts_wr = 1'b1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5, 32'h0, 1'b0, 53'h1FFFFFFFFFFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Simultaneous Control and Status Write", test_num);
            reset_dut();

            i_tl_cfg_add = 4'hF;
            i_tl_cfg_ctl = 32'hAAAA5555;
            i_tl_cfg_ctl_wr = 1'b1;
            i_tl_cfg_sts = 53'h123456789ABCDE;
            i_tl_cfg_sts_wr = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 32'hAAAA5555, 1'b1, 53'h123456789ABCDE, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Sequential Write De-assertion", test_num);
            reset_dut();


            i_tl_cfg_add = 4'h1;
            i_tl_cfg_ctl = 32'h11111111;
            i_tl_cfg_ctl_wr = 1'b1;
            @(posedge clk);
            #1;


            i_tl_cfg_ctl_wr = 1'b0;
            i_tl_cfg_add = 4'h2;
            @(posedge clk);
            #1;




            #1;





            check_outputs(4'h2, 32'h11111111, 1'b0, 53'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Synchronous Reset during Active Write", test_num);
            reset_dut();

            i_tl_cfg_add = 4'hC;
            i_tl_cfg_ctl_wr = 1'b1;
            i_tl_cfg_sts_wr = 1'b1;

            @(posedge clk);
            #1;

            srst = 1;
            @(posedge clk);
            #1;
            srst = 0;


            #1;



            check_outputs(4'h0, 32'h0, 1'b0, 53'h0, 1'b0);
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
        input [3:0] expected_o_tl_cfg_add;
        input [31:0] expected_o_tl_cfg_ctl;
        input expected_o_tl_cfg_ctl_wr;
        input [52:0] expected_o_tl_cfg_sts;
        input expected_o_tl_cfg_sts_wr;
        begin
            if (expected_o_tl_cfg_add === (expected_o_tl_cfg_add ^ o_tl_cfg_add ^ expected_o_tl_cfg_add) &&
                expected_o_tl_cfg_ctl === (expected_o_tl_cfg_ctl ^ o_tl_cfg_ctl ^ expected_o_tl_cfg_ctl) &&
                expected_o_tl_cfg_ctl_wr === (expected_o_tl_cfg_ctl_wr ^ o_tl_cfg_ctl_wr ^ expected_o_tl_cfg_ctl_wr) &&
                expected_o_tl_cfg_sts === (expected_o_tl_cfg_sts ^ o_tl_cfg_sts ^ expected_o_tl_cfg_sts) &&
                expected_o_tl_cfg_sts_wr === (expected_o_tl_cfg_sts_wr ^ o_tl_cfg_sts_wr ^ expected_o_tl_cfg_sts_wr)) begin
                $display("PASS");
                $display("  Outputs: o_tl_cfg_add=%h, o_tl_cfg_ctl=%h, o_tl_cfg_ctl_wr=%b, o_tl_cfg_sts=%h, o_tl_cfg_sts_wr=%b",
                         o_tl_cfg_add, o_tl_cfg_ctl, o_tl_cfg_ctl_wr, o_tl_cfg_sts, o_tl_cfg_sts_wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_tl_cfg_add=%h, o_tl_cfg_ctl=%h, o_tl_cfg_ctl_wr=%b, o_tl_cfg_sts=%h, o_tl_cfg_sts_wr=%b",
                         expected_o_tl_cfg_add, expected_o_tl_cfg_ctl, expected_o_tl_cfg_ctl_wr, expected_o_tl_cfg_sts, expected_o_tl_cfg_sts_wr);
                $display("  Got:      o_tl_cfg_add=%h, o_tl_cfg_ctl=%h, o_tl_cfg_ctl_wr=%b, o_tl_cfg_sts=%h, o_tl_cfg_sts_wr=%b",
                         o_tl_cfg_add, o_tl_cfg_ctl, o_tl_cfg_ctl_wr, o_tl_cfg_sts, o_tl_cfg_sts_wr);
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
        $dumpvars(0,clk, i_tl_cfg_add, i_tl_cfg_ctl, i_tl_cfg_ctl_wr, i_tl_cfg_sts, i_tl_cfg_sts_wr, srst, o_tl_cfg_add, o_tl_cfg_ctl, o_tl_cfg_ctl_wr, o_tl_cfg_sts, o_tl_cfg_sts_wr);
    end

endmodule
