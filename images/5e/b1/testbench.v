`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg brancheq;
    reg [2:0] gin;
    reg notor;
    wire [31:0] sum;
    wire zout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .brancheq(brancheq),
        .gin(gin),
        .notor(notor),
        .sum(sum),
        .zout(zout)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 32'd100;
        b = 32'd50;
        gin = OP_ADD;
        brancheq = 0;
        notor = 0;
        #1;

        check_outputs(32'd150, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 32'd100;
        b = 32'd40;
        gin = OP_SUB;
        brancheq = 0;
        notor = 0;
        #1;

        check_outputs(32'd60, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 32'hFFFF0000;
        b = 32'hAAAA5555;
        gin = OP_AND;
        brancheq = 0;
        notor = 0;
        #1;

        check_outputs(32'hAAAA0000, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 32'hF0F0F0F0;
        b = 32'h0F0F0F0F;
        gin = OP_OR;
        brancheq = 0;
        notor = 0;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 32'h0000FFFF;
        b = 32'h0;
        gin = OP_NOT;
        brancheq = 0;
        notor = 0;
        #1;

        check_outputs(32'hFFFF0000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 32'h12345678;
        b = 32'h12345678;
        gin = OP_SUB;
        brancheq = 1'b1;
        notor = 1'b0;

        #1;


        check_outputs(32'h0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 32'h12345678;
        b = 32'h00000001;
        gin = OP_SUB;
        brancheq = 1'b1;
        notor = 1'b1;
        #1;

        check_outputs(32'h12345677, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        gin = OP_ADD;
        brancheq = 0;
        notor = 0;
        #1;

        check_outputs(32'h00000000, 1'b1);
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
        input [31:0] expected_sum;
        input expected_zout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum) &&
                expected_zout === (expected_zout ^ zout ^ expected_zout)) begin
                $display("PASS");
                $display("  Outputs: sum=%h, zout=%b",
                         sum, zout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h, zout=%b",
                         expected_sum, expected_zout);
                $display("  Got:      sum=%h, zout=%b",
                         sum, zout);
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
