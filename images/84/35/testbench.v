`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] D0;
    reg [7:0] D1;
    reg [2:0] OP;
    wire [15:0] DOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D0(D0),
        .D1(D1),
        .OP(OP),
        .DOUT(DOUT)
    );
    task testcase001;

        begin
            test_num = 1;
            D0 = 16'h1234;
            D1 = 8'hFF;
            OP = 3'b000;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            D0 = 16'h000A;
            D1 = 8'h00;
            OP = 3'b001;
            #1;

            check_outputs(16'h000B);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            D0 = 16'hFFFF;
            D1 = 8'h00;
            OP = 3'b010;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            D0 = 16'h1000;
            D1 = 8'h7F;
            OP = 3'b011;
            #1;

            check_outputs(16'h107F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            D0 = 16'h1000;
            D1 = 8'h80;
            OP = 3'b011;
            #1;

            check_outputs(16'h0F80);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            D0 = 16'h0005;
            D1 = 8'h00;
            OP = 3'b100;
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            D0 = 16'h0200;
            D1 = 8'h00;
            OP = 3'b101;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            D0 = 16'hAAAA;
            D1 = 8'h55;
            OP = 3'b110;
            #1;

            check_outputs(16'hAAAA);
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
        input [15:0] expected_DOUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h",
                         DOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h",
                         expected_DOUT);
                $display("  Got:      DOUT=%h",
                         DOUT);
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
