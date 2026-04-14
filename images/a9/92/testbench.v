`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] alu_a;
    reg [31:0] alu_b;
    reg [4:0] alu_op;
    wire [31:0] alu_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_a(alu_a),
        .alu_b(alu_b),
        .alu_op(alu_op),
        .alu_out(alu_out)
    );
    task testcase001;

    begin
        test_num = 1;
        alu_a = 32'd100;
        alu_b = 32'd250;
        alu_op = 5'd0;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        alu_a = -32'd50;
        alu_b = -32'd50;
        alu_op = 5'd0;
        #1;

        check_outputs(-32'd100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        alu_a = 32'd500;
        alu_b = 32'd200;
        alu_op = 5'd1;
        #1;

        check_outputs(32'd300);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        alu_a = 32'd100;
        alu_b = 32'd200;
        alu_op = 5'd1;
        #1;

        check_outputs(-32'd100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        alu_a = 32'hAAAA_5555;
        alu_b = 32'hFFFF_0000;
        alu_op = 5'd2;
        #1;

        check_outputs(32'hAAAA_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        alu_a = 32'h1234_0000;
        alu_b = 32'h0000_5678;
        alu_op = 5'd3;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        alu_a = 32'hFFFF_FFFF;
        alu_b = 32'hAAAA_AAAA;
        alu_op = 5'd4;
        #1;

        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        alu_a = 32'h0000_0000;
        alu_b = 32'h0000_0000;
        alu_op = 5'd5;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        alu_a = 32'h7FFFFFFF;
        alu_b = 32'h7FFFFFFF;
        alu_op = 5'd1;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        alu_a = 32'h7FFFFFFF;
        alu_b = 32'd1;
        alu_op = 5'd0;
        #1;

        check_outputs(32'h80000000);
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
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_alu_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h",
                         alu_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h",
                         expected_alu_out);
                $display("  Got:      alu_out=%h",
                         alu_out);
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
