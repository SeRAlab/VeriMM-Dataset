`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] muxin_a;
    reg [31:0] muxin_b;
    reg [31:0] muxin_c;
    reg [31:0] muxin_d;
    reg [2:0] rfwb_op;
    reg rst;
    reg wb_freeze;
    wire [31:0] muxout;
    wire [31:0] muxreg;
    wire muxreg_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .muxin_a(muxin_a),
        .muxin_b(muxin_b),
        .muxin_c(muxin_c),
        .muxin_d(muxin_d),
        .rfwb_op(rfwb_op),
        .rst(rst),
        .wb_freeze(wb_freeze),
        .muxout(muxout),
        .muxreg(muxreg),
        .muxreg_valid(muxreg_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wb_freeze = 0;
            rfwb_op = 3'b000;
            muxin_a = 32'h0;
            muxin_b = 32'h0;
            muxin_c = 32'h0;
            muxin_d = 32'h0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Select muxin_a, Valid=1", test_num);
            muxin_a = 32'hAAAA_AAAA;
            rfwb_op = 3'b001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'hAAAA_AAAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Select muxin_b, Valid=0", test_num);
            muxin_b = 32'hBBBB_BBBB;
            rfwb_op = 3'b010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hBBBB_BBBB, 32'hBBBB_BBBB, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Select muxin_c, Valid=1", test_num);
            muxin_c = 32'hCCCC_CCCC;
            rfwb_op = 3'b101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCCCC_CCCC, 32'hCCCC_CCCC, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Select muxin_d (Option +8), Valid=1", test_num);
            muxin_d = 32'h0000_0010;
            rfwb_op = 3'b111;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0000_0018, 32'h0000_0018, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Test wb_freeze", test_num);

            muxin_a = 32'h1111_1111;
            rfwb_op = 3'b001;
            @(posedge clk);
            #2;


            wb_freeze = 1;
            muxin_b = 32'h2222_2222;
            rfwb_op = 3'b011;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h2222_2222, 32'h1111_1111, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Reset while data active", test_num);
            muxin_a = 32'hFFFF_FFFF;
            rfwb_op = 3'b001;
            @(posedge clk);
            #2;
            rst = 1;
            @(posedge clk);
            #2;

            if (muxreg === 32'h0) begin
                $display("PASS - muxreg reset to 0");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL - muxreg is %h after reset", muxreg);
                fail_count = fail_count + 1;
            end
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
        input [31:0] expected_muxout;
        input [31:0] expected_muxreg;
        input expected_muxreg_valid;
        begin
            if (expected_muxout === (expected_muxout ^ muxout ^ expected_muxout) &&
                expected_muxreg === (expected_muxreg ^ muxreg ^ expected_muxreg) &&
                expected_muxreg_valid === (expected_muxreg_valid ^ muxreg_valid ^ expected_muxreg_valid)) begin
                $display("PASS");
                $display("  Outputs: muxout=%h, muxreg=%h, muxreg_valid=%b",
                         muxout, muxreg, muxreg_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: muxout=%h, muxreg=%h, muxreg_valid=%b",
                         expected_muxout, expected_muxreg, expected_muxreg_valid);
                $display("  Got:      muxout=%h, muxreg=%h, muxreg_valid=%b",
                         muxout, muxreg, muxreg_valid);
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
        $dumpvars(0,clk, muxin_a, muxin_b, muxin_c, muxin_d, rfwb_op, rst, wb_freeze, muxout, muxreg, muxreg_valid);
    end

endmodule
