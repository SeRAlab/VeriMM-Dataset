`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] BWD;
    reg [31:0] SRC1;
    reg [4:0] SRC2;
    wire [4:0] DOUT;
    wire FLAG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BWD(BWD),
        .SRC1(SRC1),
        .SRC2(SRC2),
        .DOUT(DOUT),
        .FLAG(FLAG)
    );
    task testcase001;

        begin
            $display("\nStarting Testcase 001: Boundary Conditions");

            test_num = test_num + 1;
            BWD = 2'b00; SRC1 = 32'h00000000; SRC2 = 5'd0;
            #1;

            check_outputs(5'd0, 1'b1);

            test_num = test_num + 1;
            BWD = 2'b00; SRC1 = 32'hFFFFFFFF; SRC2 = 5'd0;
            #1;

            check_outputs(5'd0, 1'b0);

            test_num = test_num + 1;
            BWD = 2'b01; SRC1 = 32'h00000000; SRC2 = 5'd0;
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("\nStarting Testcase 002: Walking Ones");
            for (i = 0; i < 32; i = i + 8) begin
                test_num = test_num + 1;
                BWD = 2'b00;
                SRC1 = (32'h1 << i);
                SRC2 = 5'd0;


                #1;



                check_outputs(31-i, 1'b0);
            end
        end
        endtask

    task testcase003;

        begin
            $display("\nStarting Testcase 003: Population Count Patterns");

            test_num = test_num + 1;
            BWD = 2'b10; SRC1 = 32'h0000000F; SRC2 = 5'd0;
            #1;

            check_outputs(5'd4, 1'b0);

            test_num = test_num + 1;
            BWD = 2'b10; SRC1 = 32'h55555555; SRC2 = 5'd0;
            #1;

            check_outputs(5'd16, 1'b0);

            test_num = test_num + 1;
            BWD = 2'b10; SRC1 = 32'hAAAAAAAA; SRC2 = 5'd0;
            #1;

            check_outputs(5'd16, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nStarting Testcase 004: SRC2 Offset Logic");

            test_num = test_num + 1;
            BWD = 2'b11; SRC1 = 32'h000000F0; SRC2 = 5'd4;
            #1;

            check_outputs(5'h10, 1'b0);

            test_num = test_num + 1;
            BWD = 2'b11; SRC1 = 32'h0000FF00; SRC2 = 5'd8;
            #1;

            check_outputs(5'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nStarting Testcase 005: Mixed Data Patterns");

            test_num = test_num + 1;
            BWD = 2'b01; SRC1 = 32'h12345678; SRC2 = 5'd0;
            #1;

            check_outputs(5'd3, 1'b0);

            test_num = test_num + 1;
            BWD = 2'b00; SRC1 = 32'h00100000; SRC2 = 5'd0;
            #1;

            check_outputs(5'd11, 1'b0);
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
        input [4:0] expected_DOUT;
        input expected_FLAG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT) &&
                expected_FLAG === (expected_FLAG ^ FLAG ^ expected_FLAG)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h, FLAG=%b",
                         DOUT, FLAG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h, FLAG=%b",
                         expected_DOUT, expected_FLAG);
                $display("  Got:      DOUT=%h, FLAG=%b",
                         DOUT, FLAG);
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
