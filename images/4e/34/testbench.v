`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] avs_ctrl_byteenable;
    reg avs_ctrl_read;
    reg avs_ctrl_write;
    reg [31:0] avs_ctrl_writedata;
    reg coe_A_OCN;
    reg coe_B_OCN;
    reg csi_MCLK_clk;
    reg rsi_MRST_reset;
    wire [31:0] avs_ctrl_readdata;
    wire avs_ctrl_waitrequest;
    wire coe_A_HOE;
    wire coe_A_LOE;
    wire coe_A_PWREN;
    wire coe_B_HOE;
    wire coe_B_LOE;
    wire coe_B_PWREN;
    wire ins_OC_irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avs_ctrl_byteenable(avs_ctrl_byteenable),
        .avs_ctrl_read(avs_ctrl_read),
        .avs_ctrl_write(avs_ctrl_write),
        .avs_ctrl_writedata(avs_ctrl_writedata),
        .coe_A_OCN(coe_A_OCN),
        .coe_B_OCN(coe_B_OCN),
        .csi_MCLK_clk(csi_MCLK_clk),
        .rsi_MRST_reset(rsi_MRST_reset),
        .avs_ctrl_readdata(avs_ctrl_readdata),
        .avs_ctrl_waitrequest(avs_ctrl_waitrequest),
        .coe_A_HOE(coe_A_HOE),
        .coe_A_LOE(coe_A_LOE),
        .coe_A_PWREN(coe_A_PWREN),
        .coe_B_HOE(coe_B_HOE),
        .coe_B_LOE(coe_B_LOE),
        .coe_B_PWREN(coe_B_PWREN),
        .ins_OC_irq(ins_OC_irq)
    );

    // Clock generation (10ns period)
    initial begin
        csi_MCLK_clk = 0;
        forever #5 csi_MCLK_clk = ~csi_MCLK_clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            rsi_MRST_reset = 1;
            avs_ctrl_write = 0;
            avs_ctrl_read = 0;
            avs_ctrl_writedata = 0;
            avs_ctrl_byteenable = 4'hF;
            coe_A_OCN = 1;
            coe_B_OCN = 1;
            repeat(5) @(posedge csi_MCLK_clk);
            rsi_MRST_reset = 0;
            repeat(2) @(posedge csi_MCLK_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Check Initial Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(32'h0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Enable Channel A Controls", test_num);
            reset_dut();


            @(posedge csi_MCLK_clk);
            avs_ctrl_write = 1;
            avs_ctrl_writedata = 32'h0000_0007;
            avs_ctrl_byteenable = 4'hF;

            @(posedge csi_MCLK_clk);
            avs_ctrl_write = 0;
            repeat(2) @(posedge csi_MCLK_clk);


            #1;



            check_outputs(32'h7, 0, 1, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Enable Channel B Controls", test_num);
            reset_dut();


            @(posedge csi_MCLK_clk);
            avs_ctrl_write = 1;
            avs_ctrl_writedata = 32'h0000_0038;
            avs_ctrl_byteenable = 4'hF;

            @(posedge csi_MCLK_clk);
            avs_ctrl_write = 0;
            repeat(2) @(posedge csi_MCLK_clk);


            #1;



            check_outputs(32'h38, 0, 0, 0, 0, 1, 1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Over-Current Detection Channel A", test_num);
            reset_dut();


            @(posedge csi_MCLK_clk);
            avs_ctrl_write = 1;
            avs_ctrl_writedata = 32'h0000_0001;
            @(posedge csi_MCLK_clk);
            avs_ctrl_write = 0;


            coe_A_OCN = 0;
            repeat(2) @(posedge csi_MCLK_clk);



            #1;




            check_outputs(32'h1, 0, 0, 0, 1, 0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Over-Current Detection Channel B & Read", test_num);
            reset_dut();


            coe_B_OCN = 0;


            @(posedge csi_MCLK_clk);
            avs_ctrl_read = 1;

            @(posedge csi_MCLK_clk);


            #1;



            check_outputs(avs_ctrl_readdata, 0, 0, 0, 0, 0, 0, 0, 1);
            avs_ctrl_read = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Simultaneous Control with Byteenable", test_num);
            reset_dut();

            @(posedge csi_MCLK_clk);
            avs_ctrl_write = 1;
            avs_ctrl_writedata = 32'hFFFF_FFFF;
            avs_ctrl_byteenable = 4'h1;

            @(posedge csi_MCLK_clk);
            avs_ctrl_write = 0;
            repeat(2) @(posedge csi_MCLK_clk);


            #1;



            check_outputs(32'h3F, 0, 1, 1, 1, 1, 1, 1, 0);
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
        input [31:0] expected_avs_ctrl_readdata;
        input expected_avs_ctrl_waitrequest;
        input expected_coe_A_HOE;
        input expected_coe_A_LOE;
        input expected_coe_A_PWREN;
        input expected_coe_B_HOE;
        input expected_coe_B_LOE;
        input expected_coe_B_PWREN;
        input expected_ins_OC_irq;
        begin
            if (expected_avs_ctrl_readdata === (expected_avs_ctrl_readdata ^ avs_ctrl_readdata ^ expected_avs_ctrl_readdata) &&
                expected_avs_ctrl_waitrequest === (expected_avs_ctrl_waitrequest ^ avs_ctrl_waitrequest ^ expected_avs_ctrl_waitrequest) &&
                expected_coe_A_HOE === (expected_coe_A_HOE ^ coe_A_HOE ^ expected_coe_A_HOE) &&
                expected_coe_A_LOE === (expected_coe_A_LOE ^ coe_A_LOE ^ expected_coe_A_LOE) &&
                expected_coe_A_PWREN === (expected_coe_A_PWREN ^ coe_A_PWREN ^ expected_coe_A_PWREN) &&
                expected_coe_B_HOE === (expected_coe_B_HOE ^ coe_B_HOE ^ expected_coe_B_HOE) &&
                expected_coe_B_LOE === (expected_coe_B_LOE ^ coe_B_LOE ^ expected_coe_B_LOE) &&
                expected_coe_B_PWREN === (expected_coe_B_PWREN ^ coe_B_PWREN ^ expected_coe_B_PWREN) &&
                expected_ins_OC_irq === (expected_ins_OC_irq ^ ins_OC_irq ^ expected_ins_OC_irq)) begin
                $display("PASS");
                $display("  Outputs: avs_ctrl_readdata=%h, avs_ctrl_waitrequest=%b, coe_A_HOE=%b, coe_A_LOE=%b, coe_A_PWREN=%b, coe_B_HOE=%b, coe_B_LOE=%b, coe_B_PWREN=%b, ins_OC_irq=%b",
                         avs_ctrl_readdata, avs_ctrl_waitrequest, coe_A_HOE, coe_A_LOE, coe_A_PWREN, coe_B_HOE, coe_B_LOE, coe_B_PWREN, ins_OC_irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avs_ctrl_readdata=%h, avs_ctrl_waitrequest=%b, coe_A_HOE=%b, coe_A_LOE=%b, coe_A_PWREN=%b, coe_B_HOE=%b, coe_B_LOE=%b, coe_B_PWREN=%b, ins_OC_irq=%b",
                         expected_avs_ctrl_readdata, expected_avs_ctrl_waitrequest, expected_coe_A_HOE, expected_coe_A_LOE, expected_coe_A_PWREN, expected_coe_B_HOE, expected_coe_B_LOE, expected_coe_B_PWREN, expected_ins_OC_irq);
                $display("  Got:      avs_ctrl_readdata=%h, avs_ctrl_waitrequest=%b, coe_A_HOE=%b, coe_A_LOE=%b, coe_A_PWREN=%b, coe_B_HOE=%b, coe_B_LOE=%b, coe_B_PWREN=%b, ins_OC_irq=%b",
                         avs_ctrl_readdata, avs_ctrl_waitrequest, coe_A_HOE, coe_A_LOE, coe_A_PWREN, coe_B_HOE, coe_B_LOE, coe_B_PWREN, ins_OC_irq);
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
        $dumpvars(0,avs_ctrl_byteenable, avs_ctrl_read, avs_ctrl_write, avs_ctrl_writedata, coe_A_OCN, coe_B_OCN, csi_MCLK_clk, rsi_MRST_reset, avs_ctrl_readdata, avs_ctrl_waitrequest, coe_A_HOE, coe_A_LOE, coe_A_PWREN, coe_B_HOE, coe_B_LOE, coe_B_PWREN, ins_OC_irq);
    end

endmodule
