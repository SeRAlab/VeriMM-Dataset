`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] img_vsize;
    reg s_axis_aclk;
    reg s_axis_tlast;
    reg s_axis_tuser;
    wire FrmCmp_Irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .img_vsize(img_vsize),
        .s_axis_aclk(s_axis_aclk),
        .s_axis_tlast(s_axis_tlast),
        .s_axis_tuser(s_axis_tuser),
        .FrmCmp_Irq(FrmCmp_Irq)
    );

    // Clock generation (10ns period)
    initial begin
        s_axis_aclk = 0;
        forever #5 s_axis_aclk = ~s_axis_aclk;
    end

        task reset_dut;

        begin
            s_axis_tlast = 0;
            s_axis_tuser = 0;
            img_vsize = 0;
            @(posedge s_axis_aclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: 5-line frame completion", test_num);
            reset_dut();
            img_vsize = 12'd5;


            @(posedge s_axis_aclk);
            s_axis_tuser = 1;
            s_axis_tlast = 1;
            @(posedge s_axis_aclk);
            s_axis_tuser = 0;
            s_axis_tlast = 0;


            repeat(4) begin
                @(posedge s_axis_aclk);
                s_axis_tlast = 1;
                @(posedge s_axis_aclk);
                s_axis_tlast = 0;
            end


            repeat(2) @(posedge s_axis_aclk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: 1-line frame completion", test_num);
            reset_dut();
            img_vsize = 12'd1;

            @(posedge s_axis_aclk);
            s_axis_tuser = 1;
            s_axis_tlast = 1;
            @(posedge s_axis_aclk);
            s_axis_tuser = 0;
            s_axis_tlast = 0;

            repeat(2) @(posedge s_axis_aclk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Incomplete frame (3/5 lines)", test_num);
            reset_dut();
            img_vsize = 12'd5;

            @(posedge s_axis_aclk);
            s_axis_tuser = 1;
            s_axis_tlast = 1;
            @(posedge s_axis_aclk);
            s_axis_tuser = 0;
            s_axis_tlast = 0;


            repeat(2) begin
                @(posedge s_axis_aclk);
                s_axis_tlast = 1;
                @(posedge s_axis_aclk);
                s_axis_tlast = 0;
            end

            repeat(2) @(posedge s_axis_aclk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Consecutive frames", test_num);
            reset_dut();
            img_vsize = 12'd2;


            @(posedge s_axis_aclk);
            s_axis_tuser = 1; s_axis_tlast = 1;
            @(posedge s_axis_aclk);
            s_axis_tuser = 0; s_axis_tlast = 0;
            @(posedge s_axis_aclk);
            s_axis_tlast = 1;
            @(posedge s_axis_aclk);
            s_axis_tlast = 0;


            @(posedge s_axis_aclk);
            s_axis_tuser = 1; s_axis_tlast = 1;
            @(posedge s_axis_aclk);
            s_axis_tuser = 0; s_axis_tlast = 0;
            @(posedge s_axis_aclk);
            s_axis_tlast = 1;
            @(posedge s_axis_aclk);
            s_axis_tlast = 0;

            repeat(2) @(posedge s_axis_aclk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Mid-frame tuser reset", test_num);
            reset_dut();
            img_vsize = 12'd3;


            @(posedge s_axis_aclk);
            s_axis_tuser = 1; s_axis_tlast = 1;
            @(posedge s_axis_aclk);
            s_axis_tuser = 0; s_axis_tlast = 0;


            @(posedge s_axis_aclk);
            s_axis_tuser = 1; s_axis_tlast = 1;
            @(posedge s_axis_aclk);
            s_axis_tuser = 0; s_axis_tlast = 0;

            @(posedge s_axis_aclk);
            s_axis_tlast = 1;
            @(posedge s_axis_aclk);
            s_axis_tlast = 0;

            @(posedge s_axis_aclk);
            s_axis_tlast = 1;
            @(posedge s_axis_aclk);
            s_axis_tlast = 0;

            repeat(2) @(posedge s_axis_aclk);
            #1;

            check_outputs(1'b1);
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
        input expected_FrmCmp_Irq;
        begin
            if (expected_FrmCmp_Irq === (expected_FrmCmp_Irq ^ FrmCmp_Irq ^ expected_FrmCmp_Irq)) begin
                $display("PASS");
                $display("  Outputs: FrmCmp_Irq=%b",
                         FrmCmp_Irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FrmCmp_Irq=%b",
                         expected_FrmCmp_Irq);
                $display("  Got:      FrmCmp_Irq=%b",
                         FrmCmp_Irq);
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
        $dumpvars(0,img_vsize, s_axis_aclk, s_axis_tlast, s_axis_tuser, FrmCmp_Irq);
    end

endmodule
