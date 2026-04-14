`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] byte_num;
    reg [31:0] in;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .byte_num(byte_num),
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        in = 32'hAABBCCDD;
        byte_num = 2'b00;
        #10;
        $display("Test Case %0d: byte_num=0, in=0x%h", test_num, in);
        #1;

        check_outputs(32'h000000DD);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        in = 32'hAABBCCDD;
        byte_num = 2'b01;
        #10;
        $display("Test Case %0d: byte_num=1, in=0x%h", test_num, in);
        #1;

        check_outputs(32'h0000CCDD);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        in = 32'hAABBCCDD;
        byte_num = 2'b10;
        #10;
        $display("Test Case %0d: byte_num=2, in=0x%h", test_num, in);
        #1;

        check_outputs(32'h00BBCCDD);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        in = 32'hAABBCCDD;
        byte_num = 2'b11;
        #10;
        $display("Test Case %0d: byte_num=3, in=0x%h", test_num, in);
        #1;

        check_outputs(32'hAABBCCDD);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        in = 32'hFFFFFFFF;
        byte_num = 2'b00;
        #10;
        $display("Test Case %0d: All ones input, byte_num=0", test_num);
        #1;

        check_outputs(32'h000000FF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        in = 32'hFFFFFFFF;
        byte_num = 2'b01;
        #10;
        $display("Test Case %0d: All ones input, byte_num=1", test_num);
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        in = 32'h12345678;
        byte_num = 2'b10;
        #10;
        $display("Test Case %0d: Mixed input, byte_num=2", test_num);
        #1;

        check_outputs(32'h00345678);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        in = 32'h00000000;
        byte_num = 2'b11;
        #10;
        $display("Test Case %0d: Zero input, byte_num=3", test_num);
        #1;

        check_outputs(32'h00000000);
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
        testcase008();
        
        
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
