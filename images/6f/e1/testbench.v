`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] inst;
    reg [47:0] mem_result;
    reg reg_we;
    reg [1:0] reg_we_dst;
    reg rst;
    wire [4:0] reg_addrw;
    wire [47:0] reg_dataw;
    wire reg_we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inst(inst),
        .mem_result(mem_result),
        .reg_we(reg_we),
        .reg_we_dst(reg_we_dst),
        .rst(rst),
        .reg_addrw(reg_addrw),
        .reg_dataw(reg_dataw),
        .reg_we_o(reg_we_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: System Reset", test_num);

            rst = 1;
            inst = 32'hFFFFFFFF;
            mem_result = 48'hFFFFFFFFFFFF;
            reg_we = 1;
            reg_we_dst = 2'b11;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'd0, 48'd0, 1'b0);
            rst = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Write to rt (inst[20:16])", test_num);
            rst = 1; #10; rst = 0;


            inst = 32'h000C0000;
            mem_result = 48'hAAAA_BBBB_CCCC;
            reg_we = 1;
            reg_we_dst = 2'b00;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd12, 48'hAAAA_BBBB_CCCC, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Write to rd (inst[15:11])", test_num);
            rst = 1; #10; rst = 0;


            inst = 32'h0000F800;
            mem_result = 48'h1234_5678_9ABC;
            reg_we = 1;
            reg_we_dst = 2'b01;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd31, 48'h1234_5678_9ABC, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Write to fixed Register 31", test_num);
            rst = 1; #10; rst = 0;

            inst = 32'h0;
            mem_result = 48'hDEAD_BEEF_CAFE;
            reg_we = 1;
            reg_we_dst = 2'b10;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd31, 48'hDEAD_BEEF_CAFE, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Write Enable Gating", test_num);
            rst = 1; #10; rst = 0;

            inst = 32'h001F0000;
            mem_result = 48'hFFFF_FFFF_FFFF;
            reg_we = 0;
            reg_we_dst = 2'b00;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd31, 48'hFFFF_FFFF_FFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Max Value Integrity", test_num);
            rst = 1; #10; rst = 0;

            inst = 32'hFFFFFFFF;
            mem_result = 48'hFFFF_FFFF_FFFF;
            reg_we = 1;
            reg_we_dst = 2'b01;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd31, 48'hFFFF_FFFF_FFFF, 1'b1);
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
        input [4:0] expected_reg_addrw;
        input [47:0] expected_reg_dataw;
        input expected_reg_we_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_reg_addrw === (expected_reg_addrw ^ reg_addrw ^ expected_reg_addrw) &&
                expected_reg_dataw === (expected_reg_dataw ^ reg_dataw ^ expected_reg_dataw) &&
                expected_reg_we_o === (expected_reg_we_o ^ reg_we_o ^ expected_reg_we_o)) begin
                $display("PASS");
                $display("  Outputs: reg_addrw=%h, reg_dataw=%h, reg_we_o=%b",
                         reg_addrw, reg_dataw, reg_we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_addrw=%h, reg_dataw=%h, reg_we_o=%b",
                         expected_reg_addrw, expected_reg_dataw, expected_reg_we_o);
                $display("  Got:      reg_addrw=%h, reg_dataw=%h, reg_we_o=%b",
                         reg_addrw, reg_dataw, reg_we_o);
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
