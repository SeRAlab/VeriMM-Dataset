`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg blt_actv_1;
    reg cmdrdy;
    reg d_busy;
    reg de_clk;
    reg de_rstn;
    reg line_actv_1;
    reg noop_actv_2;
    reg pcbusy;
    wire d_cmdack;
    wire d_cmdcpyclr;
    wire [1:0] d_cs;
    wire goblt;
    wire goline;
    wire load_actvn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .blt_actv_1(blt_actv_1),
        .cmdrdy(cmdrdy),
        .d_busy(d_busy),
        .de_clk(de_clk),
        .de_rstn(de_rstn),
        .line_actv_1(line_actv_1),
        .noop_actv_2(noop_actv_2),
        .pcbusy(pcbusy),
        .d_cmdack(d_cmdack),
        .d_cmdcpyclr(d_cmdcpyclr),
        .d_cs(d_cs),
        .goblt(goblt),
        .goline(goline),
        .load_actvn(load_actvn)
    );

    // Clock generation (10ns period)
    initial begin
        de_clk = 0;
        forever #5 de_clk = ~de_clk;
    end

        task reset_dut;

        begin
            de_rstn = 0;
            blt_actv_1 = 0;
            cmdrdy = 0;
            d_busy = 0;
            line_actv_1 = 0;
            noop_actv_2 = 0;
            pcbusy = 0;
            repeat(2) @(posedge de_clk);
            #1 de_rstn = 1;
            repeat(1) @(posedge de_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset and check IDLE state", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 2'b00, 0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IDLE to DECODE (line_actv_1=1)", test_num);
            reset_dut();

            @(posedge de_clk);
            #1;
            cmdrdy = 1;
            line_actv_1 = 1;
            pcbusy = 0;

            @(posedge de_clk);
            #1;


            #1;



            check_outputs(1, 0, 2'b01, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: DECODE to BUSY transition", test_num);
            reset_dut();

            @(posedge de_clk);
            #1;
            cmdrdy = 1;
            blt_actv_1 = 1;

            @(posedge de_clk);
            @(posedge de_clk);
            #1;


            #1;



            check_outputs(0, 0, 2'b10, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: BUSY to IDLE via noop_actv_2", test_num);
            reset_dut();


            @(posedge de_clk);
            #1;
            cmdrdy = 1;
            d_busy = 1;
            @(posedge de_clk);
            @(posedge de_clk);

            #1;
            noop_actv_2 = 1;
            @(posedge de_clk);
            #1;


            #1;



            check_outputs(0, 1, 2'b00, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: BUSY to IDLE via d_busy=0", test_num);
            reset_dut();


            @(posedge de_clk);
            #1;
            cmdrdy = 1;
            d_busy = 1;
            @(posedge de_clk);
            @(posedge de_clk);

            #1;
            d_busy = 0;
            @(posedge de_clk);
            #1;
            #1;

            check_outputs(0, 1, 2'b00, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: pcbusy inhibits transition from IDLE", test_num);
            reset_dut();

            @(posedge de_clk);
            #1;
            cmdrdy = 1;
            pcbusy = 1;
            @(posedge de_clk);
            #1;

            #1;


            check_outputs(0, 0, 2'b00, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IDLE to DECODE (blt_actv_1=1)", test_num);
            reset_dut();

            @(posedge de_clk);
            #1;
            cmdrdy = 1;
            blt_actv_1 = 1;
            line_actv_1 = 0;

            @(posedge de_clk);
            #1;

            #1;


            check_outputs(1, 0, 2'b01, 1, 0, 0);
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
        input expected_d_cmdack;
        input expected_d_cmdcpyclr;
        input [1:0] expected_d_cs;
        input expected_goblt;
        input expected_goline;
        input expected_load_actvn;
        begin
            if (expected_d_cmdack === (expected_d_cmdack ^ d_cmdack ^ expected_d_cmdack) &&
                expected_d_cmdcpyclr === (expected_d_cmdcpyclr ^ d_cmdcpyclr ^ expected_d_cmdcpyclr) &&
                expected_d_cs === (expected_d_cs ^ d_cs ^ expected_d_cs) &&
                expected_goblt === (expected_goblt ^ goblt ^ expected_goblt) &&
                expected_goline === (expected_goline ^ goline ^ expected_goline) &&
                expected_load_actvn === (expected_load_actvn ^ load_actvn ^ expected_load_actvn)) begin
                $display("PASS");
                $display("  Outputs: d_cmdack=%b, d_cmdcpyclr=%b, d_cs=%h, goblt=%b, goline=%b, load_actvn=%b",
                         d_cmdack, d_cmdcpyclr, d_cs, goblt, goline, load_actvn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_cmdack=%b, d_cmdcpyclr=%b, d_cs=%h, goblt=%b, goline=%b, load_actvn=%b",
                         expected_d_cmdack, expected_d_cmdcpyclr, expected_d_cs, expected_goblt, expected_goline, expected_load_actvn);
                $display("  Got:      d_cmdack=%b, d_cmdcpyclr=%b, d_cs=%h, goblt=%b, goline=%b, load_actvn=%b",
                         d_cmdack, d_cmdcpyclr, d_cs, goblt, goline, load_actvn);
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
        $dumpvars(0,blt_actv_1, cmdrdy, d_busy, de_clk, de_rstn, line_actv_1, noop_actv_2, pcbusy, d_cmdack, d_cmdcpyclr, d_cs, goblt, goline, load_actvn);
    end

endmodule
