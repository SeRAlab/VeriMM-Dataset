`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] avs_s0_address;
    reg [3:0] avs_s0_byteenable;
    reg avs_s0_read;
    reg avs_s0_write;
    reg [31:0] avs_s0_writedata;
    reg clock_clk;
    reg reset_reset;
    wire [31:0] avs_s0_readdata;
    wire avs_s0_readdatavalid;
    wire avs_s0_waitrequest;
    wire ins_irq0_irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avs_s0_address(avs_s0_address),
        .avs_s0_byteenable(avs_s0_byteenable),
        .avs_s0_read(avs_s0_read),
        .avs_s0_write(avs_s0_write),
        .avs_s0_writedata(avs_s0_writedata),
        .clock_clk(clock_clk),
        .reset_reset(reset_reset),
        .avs_s0_readdata(avs_s0_readdata),
        .avs_s0_readdatavalid(avs_s0_readdatavalid),
        .avs_s0_waitrequest(avs_s0_waitrequest),
        .ins_irq0_irq(ins_irq0_irq)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: System Reset and Default State", test_num);


        reset_reset = 1;
        avs_s0_address = 4'h0;
        avs_s0_read = 0;
        avs_s0_write = 0;
        avs_s0_writedata = 32'h0;
        avs_s0_byteenable = 4'h0;

        @(posedge clock_clk);
        #1 reset_reset = 0;
        @(posedge clock_clk);


        #1;



        check_outputs(32'h0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic Read Request (Address 0x5)", test_num);

        reset_reset = 1;
        @(posedge clock_clk);
        #1 reset_reset = 0;


        avs_s0_address = 4'h5;
        avs_s0_read = 1;
        avs_s0_byteenable = 4'hF;

        @(posedge clock_clk);


        #1;



        check_outputs(32'h0, 1'b0, 1'b0, 1'b0);

        #1 avs_s0_read = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic Write Request (Address 0xA)", test_num);

        reset_reset = 1;
        @(posedge clock_clk);
        #1 reset_reset = 0;


        avs_s0_address = 4'hA;
        avs_s0_write = 1;
        avs_s0_writedata = 32'hDEADBEEF;
        avs_s0_byteenable = 4'hF;

        @(posedge clock_clk);
        #1;

        check_outputs(32'h0, 1'b0, 1'b0, 1'b0);

        #1 avs_s0_write = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Interrupt Signal Check", test_num);

        reset_reset = 1;
        @(posedge clock_clk);
        #1 reset_reset = 0;


        avs_s0_address = 4'hF;
        avs_s0_read = 1;
        avs_s0_write = 1;

        @(posedge clock_clk);

        #1;


        check_outputs(32'h0, 1'b0, 1'b0, 1'b0);

        #1;
        avs_s0_read = 0;
        avs_s0_write = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Boundary Address and ByteEnable Check", test_num);

        reset_reset = 1;
        @(posedge clock_clk);
        #1 reset_reset = 0;

        avs_s0_address = 4'hF;
        avs_s0_read = 1;
        avs_s0_byteenable = 4'h3;

        @(posedge clock_clk);
        #1;

        check_outputs(32'h0, 1'b0, 1'b0, 1'b0);

        #1 avs_s0_read = 0;
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
        input [31:0] expected_avs_s0_readdata;
        input expected_avs_s0_readdatavalid;
        input expected_avs_s0_waitrequest;
        input expected_ins_irq0_irq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_avs_s0_readdata === (expected_avs_s0_readdata ^ avs_s0_readdata ^ expected_avs_s0_readdata) &&
                expected_avs_s0_readdatavalid === (expected_avs_s0_readdatavalid ^ avs_s0_readdatavalid ^ expected_avs_s0_readdatavalid) &&
                expected_avs_s0_waitrequest === (expected_avs_s0_waitrequest ^ avs_s0_waitrequest ^ expected_avs_s0_waitrequest) &&
                expected_ins_irq0_irq === (expected_ins_irq0_irq ^ ins_irq0_irq ^ expected_ins_irq0_irq)) begin
                $display("PASS");
                $display("  Outputs: avs_s0_readdata=%h, avs_s0_readdatavalid=%b, avs_s0_waitrequest=%b, ins_irq0_irq=%b",
                         avs_s0_readdata, avs_s0_readdatavalid, avs_s0_waitrequest, ins_irq0_irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avs_s0_readdata=%h, avs_s0_readdatavalid=%b, avs_s0_waitrequest=%b, ins_irq0_irq=%b",
                         expected_avs_s0_readdata, expected_avs_s0_readdatavalid, expected_avs_s0_waitrequest, expected_ins_irq0_irq);
                $display("  Got:      avs_s0_readdata=%h, avs_s0_readdatavalid=%b, avs_s0_waitrequest=%b, ins_irq0_irq=%b",
                         avs_s0_readdata, avs_s0_readdatavalid, avs_s0_waitrequest, ins_irq0_irq);
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
