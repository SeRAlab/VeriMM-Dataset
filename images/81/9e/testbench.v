`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 32'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 32'd1;
        #1;

        check_outputs(16'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 32'd4;
        #1;

        check_outputs(16'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 32'd3;
        #1;

        check_outputs(16'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 32'd15;
        #1;

        check_outputs(16'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 32'd100;
        #1;

        check_outputs(16'd10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 32'd65536;
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 32'h40000000;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 32'hFFFE0001;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in = 32'hFFFFFFFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        in = 32'd1000000;
        #1;

        check_outputs(16'd1000);
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
        testcase011();
        
        
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
        input [15:0] expected_out;
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
