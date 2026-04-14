`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg avm_waitrequest;
    reg avm_writeack;
    reg clk;
    reg [31:0] i_address;
    reg [3:0] i_byteenable;
    reg i_stall;
    reg i_valid;
    reg [31:0] i_writedata;
    reg reset;
    wire [31:0] avm_address;
    wire [31:0] avm_byteenable;
    wire avm_enable;
    wire avm_write;
    wire [255:0] avm_writedata;
    wire o_active;
    wire o_stall;
    wire o_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avm_waitrequest(avm_waitrequest),
        .avm_writeack(avm_writeack),
        .clk(clk),
        .i_address(i_address),
        .i_byteenable(i_byteenable),
        .i_stall(i_stall),
        .i_valid(i_valid),
        .i_writedata(i_writedata),
        .reset(reset),
        .avm_address(avm_address),
        .avm_byteenable(avm_byteenable),
        .avm_enable(avm_enable),
        .avm_write(avm_write),
        .avm_writedata(avm_writedata),
        .o_active(o_active),
        .o_stall(o_stall),
        .o_valid(o_valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Reset State", test_num);
            reset = 1;
            i_valid = 0;
            i_address = 0;
            i_writedata = 0;
            i_byteenable = 0;
            i_stall = 0;
            avm_waitrequest = 0;
            avm_writeack = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);

            #1;


            check_outputs(32'h0, 32'h0, 1'b0, 1'b0, 256'h0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Simple Write (No wait, fast ack)", test_num);
            reset = 1; #10; reset = 0; @(posedge clk);

            i_valid = 1;
            i_address = 32'hAAAA_BBBB;
            i_writedata = 32'h1234_5678;
            i_byteenable = 4'hF;

            @(posedge clk);
            i_valid = 0;
            avm_writeack = 1;

            @(posedge clk);
            avm_writeack = 0;

            #1;


            check_outputs(32'hAAAA_BBBB, 32'h0000_000F, 1'b1, 1'b1, {224'h0, 32'h1234_5678}, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Slave Wait Request", test_num);
            reset = 1; #10; reset = 0; @(posedge clk);

            avm_waitrequest = 1;
            i_valid = 1;
            i_address = 32'hCCCC_DDDD;
            i_writedata = 32'hCAFE_BABE;
            i_byteenable = 4'h3;

            repeat(2) @(posedge clk);

            avm_waitrequest = 0;
            @(posedge clk);
            avm_writeack = 1;
            @(posedge clk);
            avm_writeack = 0;

            #1;


            check_outputs(32'hCCCC_DDDD, 32'h0000_0003, 1'b1, 1'b1, {224'h0, 32'hCAFE_BABE}, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Delayed Write Ack", test_num);
            reset = 1; #10; reset = 0; @(posedge clk);

            i_valid = 1;
            i_address = 32'h0000_1000;
            i_writedata = 32'hDEAD_BEEF;
            i_byteenable = 4'hC;

            @(posedge clk);
            i_valid = 0;

            repeat(3) @(posedge clk);
            avm_writeack = 1;
            @(posedge clk);
            avm_writeack = 0;

            #1;


            check_outputs(32'h0000_1000, 32'h0000_000C, 1'b1, 1'b1, {224'h0, 32'hDEAD_BEEF}, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Downstream i_stall", test_num);
            reset = 1; #10; reset = 0; @(posedge clk);

            i_stall = 1;
            i_valid = 1;
            i_address = 32'h8888_9999;
            i_writedata = 32'h55AA_55AA;
            i_byteenable = 4'hF;

            @(posedge clk);
            i_valid = 0;
            avm_writeack = 1;
            @(posedge clk);
            avm_writeack = 0;



            repeat(2) @(posedge clk);
            i_stall = 0;
            @(posedge clk);

            #1;


            check_outputs(32'h8888_9999, 32'h0000_000F, 1'b1, 1'b1, {224'h0, 32'h55AA_55AA}, 1'b0, 1'b0, 1'b1);
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
        input [31:0] expected_avm_address;
        input [31:0] expected_avm_byteenable;
        input expected_avm_enable;
        input expected_avm_write;
        input [255:0] expected_avm_writedata;
        input expected_o_active;
        input expected_o_stall;
        input expected_o_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_avm_address === (expected_avm_address ^ avm_address ^ expected_avm_address) &&
                expected_avm_byteenable === (expected_avm_byteenable ^ avm_byteenable ^ expected_avm_byteenable) &&
                expected_avm_enable === (expected_avm_enable ^ avm_enable ^ expected_avm_enable) &&
                expected_avm_write === (expected_avm_write ^ avm_write ^ expected_avm_write) &&
                expected_avm_writedata === (expected_avm_writedata ^ avm_writedata ^ expected_avm_writedata) &&
                expected_o_active === (expected_o_active ^ o_active ^ expected_o_active) &&
                expected_o_stall === (expected_o_stall ^ o_stall ^ expected_o_stall) &&
                expected_o_valid === (expected_o_valid ^ o_valid ^ expected_o_valid)) begin
                $display("PASS");
                $display("  Outputs: avm_address=%h, avm_byteenable=%h, avm_enable=%b, avm_write=%b, avm_writedata=%h, o_active=%b, o_stall=%b, o_valid=%b",
                         avm_address, avm_byteenable, avm_enable, avm_write, avm_writedata, o_active, o_stall, o_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avm_address=%h, avm_byteenable=%h, avm_enable=%b, avm_write=%b, avm_writedata=%h, o_active=%b, o_stall=%b, o_valid=%b",
                         expected_avm_address, expected_avm_byteenable, expected_avm_enable, expected_avm_write, expected_avm_writedata, expected_o_active, expected_o_stall, expected_o_valid);
                $display("  Got:      avm_address=%h, avm_byteenable=%h, avm_enable=%b, avm_write=%b, avm_writedata=%h, o_active=%b, o_stall=%b, o_valid=%b",
                         avm_address, avm_byteenable, avm_enable, avm_write, avm_writedata, o_active, o_stall, o_valid);
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
