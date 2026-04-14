`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] sel;
    wire [4:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sel(sel),
        .q(q)
    );
    task testcase001;

    begin
        test_num = 1;
        sel = 32'h0000_0001;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        sel = 32'h0000_0002;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        sel = 32'h0000_0010;
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        sel = 32'h0000_8000;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        sel = 32'h8000_0000;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        sel = 32'h0000_0007;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        sel = 32'hF0F0_0000;
        #1;

        check_outputs(5'd20);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        sel = (1 << 10);
        #1;

        check_outputs(5'd10);
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
        input [4:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
