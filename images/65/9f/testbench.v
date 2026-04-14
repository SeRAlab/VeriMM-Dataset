`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] num;
    reg [1:0] op_sel;
    reg [4:0] shift;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num(num),
        .op_sel(op_sel),
        .shift(shift),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            num = 32'h0000_0001;
            shift = 5'd4;
            op_sel = 2'b00;
            #1;

            check_outputs(32'h0000_0010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            num = 32'h8000_0001;
            shift = 5'd1;
            op_sel = 2'b00;
            #1;

            check_outputs(32'h0000_0002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            num = 32'h8000_0000;
            shift = 5'd1;
            op_sel = 2'b01;
            #1;

            check_outputs(32'h4000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            num = 32'hFFFF_FFFF;
            shift = 5'd16;
            op_sel = 2'b01;
            #1;

            check_outputs(32'h0000_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            num = 32'h4000_0000;
            shift = 5'd2;
            op_sel = 2'b10;
            #1;

            check_outputs(32'h1000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            num = 32'h8000_0000;
            shift = 5'd4;
            op_sel = 2'b10;
            #1;

            check_outputs(32'hF800_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            num = 32'hDEAD_BEEF;
            shift = 5'd10;
            op_sel = 2'b11;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            num = 32'hAAAA_BBBB;
            shift = 5'd0;
            op_sel = 2'b00;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            num = 32'h8000_0000;
            shift = 5'd31;
            op_sel = 2'b01;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            num = 32'h8000_0000;
            shift = 5'd31;
            op_sel = 2'b10;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
