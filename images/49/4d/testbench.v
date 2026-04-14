`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg en;
    reg [3:0] op;
    wire [63:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .en(en),
        .op(op),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 32'h0000_000A;
        B = 32'h0000_0014;
        op = 4'd0;
        en = 1'b1;
        #1;

        check_outputs(64'h0000_0000_0000_001E);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 32'h0000_0064;
        B = 32'h0000_001E;
        op = 4'd1;
        en = 1'b1;
        #1;

        check_outputs(64'h0000_0000_0000_0046);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 32'h0000_000C;
        B = 32'h0000_000B;
        op = 4'd2;
        en = 1'b1;
        #1;

        check_outputs(64'h0000_0000_0000_0084);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 32'hF0F0_F0F0;
        B = 32'hFFFF_0000;
        op = 4'd3;
        en = 1'b1;
        #1;

        check_outputs(64'h0000_0000_F0F0_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 32'hAAAA_AAAA;
        B = 32'h5555_5555;
        op = 4'd4;
        en = 1'b1;
        #1;

        check_outputs(64'h0000_0000_FFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 32'hF0F0_F0F0;
        B = 32'h0000_0000;
        op = 4'd5;
        en = 1'b1;
        #1;

        check_outputs(64'h0000_0000_0F0F_0F0F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0001;
        op = 4'd0;
        en = 1'b1;
        #1;

        check_outputs(64'h0000_0001_0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 32'hFFFF_FFFF;
        B = 32'hFFFF_FFFF;
        op = 4'd2;
        en = 1'b1;
        #1;

        check_outputs(64'hFFFE_0000_0000_0001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 32'h0000_0000;
        B = 32'h0000_0001;
        op = 4'd1;
        en = 1'b1;
        #1;

        check_outputs(64'h0000_0000_FFFF_FFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0000;
        op = 4'd3;
        en = 1'b1;
        #1;

        check_outputs(64'h0000_0000_0000_0000);
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
        input [63:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
