`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] daddr;
    reg de;
    reg [31:0] din;
    reg [1:0] drw;
    reg [31:0] iaddr;
    reg ie;
    reg rst;
    wire [31:0] dout;
    wire [31:0] iout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .daddr(daddr),
        .de(de),
        .din(din),
        .drw(drw),
        .iaddr(iaddr),
        .ie(ie),
        .rst(rst),
        .dout(dout),
        .iout(iout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Access CPU ID (daddr=0, de=1)", test_num);

        rst = 1; daddr = 0; de = 0; din = 0; drw = 0; iaddr = 0; ie = 0;
        #20 rst = 0;

        @(posedge clk);
        de = 1;
        daddr = 32'h0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(CPU_ID_VAL, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Access Board Freq (daddr=4, de=1)", test_num);

        rst = 1; de = 0;
        #20 rst = 0;

        @(posedge clk);
        de = 1;
        daddr = 32'h4;
        @(posedge clk);
        #2;
        #1;

        check_outputs(FREQ_VAL, 32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Access Invalid Data Address (daddr=8)", test_num);

        rst = 1;
        #20 rst = 0;

        @(posedge clk);
        de = 1;
        daddr = 32'h8;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Access with Data Enable Low (de=0)", test_num);

        rst = 1;
        #20 rst = 0;

        @(posedge clk);
        de = 0;
        daddr = 32'h0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset signal during valid access", test_num);

        rst = 0; de = 1; daddr = 32'h4;
        @(posedge clk);

        rst = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h0, 32'h0);
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
        input [31:0] expected_dout;
        input [31:0] expected_iout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_iout === (expected_iout ^ iout ^ expected_iout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, iout=%h",
                         dout, iout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, iout=%h",
                         expected_dout, expected_iout);
                $display("  Got:      dout=%h, iout=%h",
                         dout, iout);
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

endmodule
