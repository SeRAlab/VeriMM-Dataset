`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] avm_m0_readdata;
    reg avm_m0_waitrequest;
    reg [7:0] avs_s0_address;
    reg avs_s0_read;
    reg avs_s0_write;
    reg [31:0] avs_s0_writedata;
    reg clock_clk;
    reg reset_reset;
    wire [7:0] avm_m0_address;
    wire avm_m0_read;
    wire avm_m0_write;
    wire [31:0] avm_m0_writedata;
    wire [31:0] avs_s0_readdata;
    wire avs_s0_waitrequest;
    wire ins_irq0_irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avm_m0_readdata(avm_m0_readdata),
        .avm_m0_waitrequest(avm_m0_waitrequest),
        .avs_s0_address(avs_s0_address),
        .avs_s0_read(avs_s0_read),
        .avs_s0_write(avs_s0_write),
        .avs_s0_writedata(avs_s0_writedata),
        .clock_clk(clock_clk),
        .reset_reset(reset_reset),
        .avm_m0_address(avm_m0_address),
        .avm_m0_read(avm_m0_read),
        .avm_m0_write(avm_m0_write),
        .avm_m0_writedata(avm_m0_writedata),
        .avs_s0_readdata(avs_s0_readdata),
        .avs_s0_waitrequest(avs_s0_waitrequest),
        .ins_irq0_irq(ins_irq0_irq)
    );
    task init_inputs;

        begin
            avm_m0_readdata = 32'h0;
            avm_m0_waitrequest = 1'b0;
            avs_s0_address = 8'h0;
            avs_s0_read = 1'b0;
            avs_s0_write = 1'b0;
            avs_s0_writedata = 32'h0;
            clock_clk = 1'b0;
            reset_reset = 1'b0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Reset State", test_num);
            init_inputs();
            reset_reset = 1;
            @(posedge clock_clk);
            #1 reset_reset = 0;
            @(posedge clock_clk);


            #1;



            check_outputs(8'h00, 1'b0, 1'b0, 32'h0, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Slave Read Attempt", test_num);
            init_inputs();
            reset_reset = 1; @(posedge clock_clk); reset_reset = 0;

            @(posedge clock_clk);
            avs_s0_address = 8'hFF;
            avs_s0_read = 1'b1;

            repeat(2) @(posedge clock_clk);
            #1;

            check_outputs(8'h00, 1'b0, 1'b0, 32'h0, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Slave Write Attempt", test_num);
            init_inputs();
            reset_reset = 1; @(posedge clock_clk); reset_reset = 0;

            @(posedge clock_clk);
            avs_s0_address = 8'h42;
            avs_s0_write = 1'b1;
            avs_s0_writedata = 32'hDEADBEEF;

            repeat(2) @(posedge clock_clk);
            #1;

            check_outputs(8'h00, 1'b0, 1'b0, 32'h0, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Master Input Feedback", test_num);
            init_inputs();
            reset_reset = 1; @(posedge clock_clk); reset_reset = 0;

            @(posedge clock_clk);
            avm_m0_readdata = 32'hCAFEBABE;
            avm_m0_waitrequest = 1'b1;

            repeat(2) @(posedge clock_clk);
            #1;

            check_outputs(8'h00, 1'b0, 1'b0, 32'h0, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Concurrent Activity", test_num);
            init_inputs();
            reset_reset = 1; @(posedge clock_clk); reset_reset = 0;

            @(posedge clock_clk);
            avs_s0_address = 8'h01;
            avs_s0_read = 1'b1;
            avs_s0_write = 1'b1;
            avs_s0_writedata = 32'h12345678;
            avm_m0_waitrequest = 1'b1;

            repeat(5) @(posedge clock_clk);
            #1;

            check_outputs(8'h00, 1'b0, 1'b0, 32'h0, 32'h0, 1'b0, 1'b0);
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
        input [7:0] expected_avm_m0_address;
        input expected_avm_m0_read;
        input expected_avm_m0_write;
        input [31:0] expected_avm_m0_writedata;
        input [31:0] expected_avs_s0_readdata;
        input expected_avs_s0_waitrequest;
        input expected_ins_irq0_irq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_avm_m0_address === (expected_avm_m0_address ^ avm_m0_address ^ expected_avm_m0_address) &&
                expected_avm_m0_read === (expected_avm_m0_read ^ avm_m0_read ^ expected_avm_m0_read) &&
                expected_avm_m0_write === (expected_avm_m0_write ^ avm_m0_write ^ expected_avm_m0_write) &&
                expected_avm_m0_writedata === (expected_avm_m0_writedata ^ avm_m0_writedata ^ expected_avm_m0_writedata) &&
                expected_avs_s0_readdata === (expected_avs_s0_readdata ^ avs_s0_readdata ^ expected_avs_s0_readdata) &&
                expected_avs_s0_waitrequest === (expected_avs_s0_waitrequest ^ avs_s0_waitrequest ^ expected_avs_s0_waitrequest) &&
                expected_ins_irq0_irq === (expected_ins_irq0_irq ^ ins_irq0_irq ^ expected_ins_irq0_irq)) begin
                $display("PASS");
                $display("  Outputs: avm_m0_address=%h, avm_m0_read=%b, avm_m0_write=%b, avm_m0_writedata=%h, avs_s0_readdata=%h, avs_s0_waitrequest=%b, ins_irq0_irq=%b",
                         avm_m0_address, avm_m0_read, avm_m0_write, avm_m0_writedata, avs_s0_readdata, avs_s0_waitrequest, ins_irq0_irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avm_m0_address=%h, avm_m0_read=%b, avm_m0_write=%b, avm_m0_writedata=%h, avs_s0_readdata=%h, avs_s0_waitrequest=%b, ins_irq0_irq=%b",
                         expected_avm_m0_address, expected_avm_m0_read, expected_avm_m0_write, expected_avm_m0_writedata, expected_avs_s0_readdata, expected_avs_s0_waitrequest, expected_ins_irq0_irq);
                $display("  Got:      avm_m0_address=%h, avm_m0_read=%b, avm_m0_write=%b, avm_m0_writedata=%h, avs_s0_readdata=%h, avs_s0_waitrequest=%b, ins_irq0_irq=%b",
                         avm_m0_address, avm_m0_read, avm_m0_write, avm_m0_writedata, avs_s0_readdata, avs_s0_waitrequest, ins_irq0_irq);
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
