`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bs_adr;
    reg [15:0] bs_din;
    reg bs_rst;
    reg bs_stb;
    reg bs_we;
    reg pclk;
    wire [15:0] bs_dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bs_adr(bs_adr),
        .bs_din(bs_din),
        .bs_rst(bs_rst),
        .bs_stb(bs_stb),
        .bs_we(bs_we),
        .pclk(pclk),
        .bs_dout(bs_dout)
    );

    // Clock generation (10ns period)
    initial begin
        pclk = 0;
        forever #5 pclk = ~pclk;
    end

        task reset_dut;

        begin
            bs_rst = 1;
            bs_stb = 0;
            bs_we = 0;
            bs_adr = 0;
            bs_din = 0;
            repeat(2) @(posedge pclk);
            bs_rst = 0;
            repeat(1) @(posedge pclk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset State Output", test_num);
            reset_dut();

            #1;


            check_outputs(16'hzzzz);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Idle Bus (Not Selected)", test_num);
            reset_dut();
            bs_adr = 8'hFF;
            bs_stb = 0;
            bs_we = 0;
            repeat(2) @(posedge pclk);
            #1;

            check_outputs(16'hzzzz);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write then Read Status", test_num);
            reset_dut();


            @(posedge pclk);
            bs_adr = 8'h00;
            bs_din = 16'h0001;
            bs_stb = 1;
            bs_we = 1;
            @(posedge pclk);


            bs_we = 0;
            bs_din = 16'h0000;
            repeat(2) @(posedge pclk);



            #1;




            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: High-Z during Reset Signal", test_num);
            reset_dut();
            @(posedge pclk);
            bs_rst = 1;
            bs_stb = 1;
            bs_adr = 8'h00;
            repeat(1) @(posedge pclk);
            #1;

            check_outputs(16'hzzzz);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write with data triggering busy", test_num);
            reset_dut();
            @(posedge pclk);
            bs_adr = 8'h00;
            bs_din = 16'hFFFF;
            bs_stb = 1;
            bs_we = 1;
            @(posedge pclk);
            bs_stb = 0;
            bs_we = 0;
            repeat(1) @(posedge pclk);

            #1;


            check_outputs(16'hzzzz);
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
        input [15:0] expected_bs_dout;
        begin
            if (expected_bs_dout === (expected_bs_dout ^ bs_dout ^ expected_bs_dout)) begin
                $display("PASS");
                $display("  Outputs: bs_dout=%h",
                         bs_dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bs_dout=%h",
                         expected_bs_dout);
                $display("  Got:      bs_dout=%h",
                         bs_dout);
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
        $dumpvars(0,bs_adr, bs_din, bs_rst, bs_stb, bs_we, pclk, bs_dout);
    end

endmodule
