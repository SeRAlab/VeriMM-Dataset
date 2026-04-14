`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] in;
    reg [4:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;

        in = 128'hFEDCBA9876543210FEDCBA9876543210;
        sel = 5'd0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        in = 128'hFEDCBA9876543210FEDCBA9876543210;
        sel = 5'd31;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;


        in = 128'hFEDCBA9876543210FEDCBA9876543210;
        sel = 5'd16;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        in = {128{1'b1}};
        sel = 5'd15;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        in = {128{1'b0}};
        sel = 5'd7;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;


        in = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;


        sel = 5'd1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;

        in = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;


        sel = 5'd0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;

        in = 128'hFEDCBA9876543210FEDCBA9876543210;
        sel = 5'd30;
        #1;

        check_outputs(4'hE);
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
        input [3:0] expected_out;
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
