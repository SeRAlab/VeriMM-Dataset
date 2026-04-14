`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] asi_ledf_data;
    reg asi_ledf_valid;
    reg [3:0] avs_ctrl_byteenable;
    reg avs_ctrl_read;
    reg avs_ctrl_write;
    reg [31:0] avs_ctrl_writedata;
    reg csi_MCLK_clk;
    reg rsi_MRST_reset;
    wire [31:0] avs_ctrl_readdata;
    wire avs_ctrl_waitrequest;
    wire coe_LED_B;
    wire coe_LED_G;
    wire coe_LED_R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .asi_ledf_data(asi_ledf_data),
        .asi_ledf_valid(asi_ledf_valid),
        .avs_ctrl_byteenable(avs_ctrl_byteenable),
        .avs_ctrl_read(avs_ctrl_read),
        .avs_ctrl_write(avs_ctrl_write),
        .avs_ctrl_writedata(avs_ctrl_writedata),
        .csi_MCLK_clk(csi_MCLK_clk),
        .rsi_MRST_reset(rsi_MRST_reset),
        .avs_ctrl_readdata(avs_ctrl_readdata),
        .avs_ctrl_waitrequest(avs_ctrl_waitrequest),
        .coe_LED_B(coe_LED_B),
        .coe_LED_G(coe_LED_G),
        .coe_LED_R(coe_LED_R)
    );

    // Clock generation (10ns period)
    initial begin
        csi_MCLK_clk = 0;
        forever #5 csi_MCLK_clk = ~csi_MCLK_clk;
    end

        task reset_dut;

        begin
            rsi_MRST_reset = 1;
            asi_ledf_data = 24'b0;
            asi_ledf_valid = 0;
            avs_ctrl_byteenable = 4'h0;
            avs_ctrl_read = 0;
            avs_ctrl_write = 0;
            avs_ctrl_writedata = 32'b0;
            repeat(2) @(posedge csi_MCLK_clk);
            rsi_MRST_reset = 0;
            repeat(2) @(posedge csi_MCLK_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Default state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Streaming Interface - Full White (0xFFFFFF)", test_num);
            reset_dut();


            @(posedge csi_MCLK_clk);
            asi_ledf_data = 24'hFFFFFF;
            asi_ledf_valid = 1;
            @(posedge csi_MCLK_clk);
            asi_ledf_valid = 0;


            repeat(5) @(posedge csi_MCLK_clk);



            #1;




            check_outputs(32'h0, 1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Avalon Write Interface - Red Only", test_num);
            reset_dut();



            @(posedge csi_MCLK_clk);
            avs_ctrl_writedata = 32'h00FF0000;
            avs_ctrl_byteenable = 4'hF;
            avs_ctrl_write = 1;


            while(avs_ctrl_waitrequest) @(posedge csi_MCLK_clk);
            @(posedge csi_MCLK_clk);
            avs_ctrl_write = 0;

            repeat(5) @(posedge csi_MCLK_clk);


            #1;



            check_outputs(32'h0, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Avalon Read Interface", test_num);
            reset_dut();


            @(posedge csi_MCLK_clk);
            avs_ctrl_writedata = 32'h0000FF00;
            avs_ctrl_write = 1;
            avs_ctrl_byteenable = 4'hF;
            while(avs_ctrl_waitrequest) @(posedge csi_MCLK_clk);
            @(posedge csi_MCLK_clk);
            avs_ctrl_write = 0;


            @(posedge csi_MCLK_clk);
            avs_ctrl_read = 1;
            while(avs_ctrl_waitrequest) @(posedge csi_MCLK_clk);
            @(posedge csi_MCLK_clk);



            #1;




            check_outputs(32'h0000FF00, 1'b0, 1'b0, 1'b1, 1'b0);
            avs_ctrl_read = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: PWM Low Intensity (0x00)", test_num);
            reset_dut();


            @(posedge csi_MCLK_clk);
            asi_ledf_data = 24'h000000;
            asi_ledf_valid = 1;
            @(posedge csi_MCLK_clk);
            asi_ledf_valid = 0;


            repeat(10) @(posedge csi_MCLK_clk);


            #1;



            check_outputs(32'h0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Avalon Byte Enable Test", test_num);
            reset_dut();


            @(posedge csi_MCLK_clk);
            avs_ctrl_writedata = 32'hFFFFFFFF;
            avs_ctrl_byteenable = 4'b0001;
            avs_ctrl_write = 1;
            while(avs_ctrl_waitrequest) @(posedge csi_MCLK_clk);
            @(posedge csi_MCLK_clk);
            avs_ctrl_write = 0;

            repeat(5) @(posedge csi_MCLK_clk);


            #1;



            check_outputs(32'h0, 1'b0, 1'b1, 1'b0, 1'b0);
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
        input expected_coe_LED_B;
        input expected_coe_LED_G;
        input expected_coe_LED_R;
        begin
            if (expected_avs_ctrl_readdata === (expected_avs_ctrl_readdata ^ avs_ctrl_readdata ^ expected_avs_ctrl_readdata) &&
                expected_avs_ctrl_waitrequest === (expected_avs_ctrl_waitrequest ^ avs_ctrl_waitrequest ^ expected_avs_ctrl_waitrequest) &&
                expected_coe_LED_B === (expected_coe_LED_B ^ coe_LED_B ^ expected_coe_LED_B) &&
                expected_coe_LED_G === (expected_coe_LED_G ^ coe_LED_G ^ expected_coe_LED_G) &&
                expected_coe_LED_R === (expected_coe_LED_R ^ coe_LED_R ^ expected_coe_LED_R)) begin
                $display("PASS");
                $display("  Outputs: avs_ctrl_readdata=%h, avs_ctrl_waitrequest=%b, coe_LED_B=%b, coe_LED_G=%b, coe_LED_R=%b",
                         avs_ctrl_readdata, avs_ctrl_waitrequest, coe_LED_B, coe_LED_G, coe_LED_R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avs_ctrl_readdata=%h, avs_ctrl_waitrequest=%b, coe_LED_B=%b, coe_LED_G=%b, coe_LED_R=%b",
                         expected_avs_ctrl_readdata, expected_avs_ctrl_waitrequest, expected_coe_LED_B, expected_coe_LED_G, expected_coe_LED_R);
                $display("  Got:      avs_ctrl_readdata=%h, avs_ctrl_waitrequest=%b, coe_LED_B=%b, coe_LED_G=%b, coe_LED_R=%b",
                         avs_ctrl_readdata, avs_ctrl_waitrequest, coe_LED_B, coe_LED_G, coe_LED_R);
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
        $dumpvars(0,asi_ledf_data, asi_ledf_valid, avs_ctrl_byteenable, avs_ctrl_read, avs_ctrl_write, avs_ctrl_writedata, csi_MCLK_clk, rsi_MRST_reset, avs_ctrl_readdata, avs_ctrl_waitrequest, coe_LED_B, coe_LED_G, coe_LED_R);
    end

endmodule
