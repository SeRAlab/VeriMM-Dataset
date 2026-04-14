`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    wire [15:0] w;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .w(w)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 3'b000;
        #1;

        check_outputs(16'h0006);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 3'b001;
        #1;

        check_outputs(16'h0078);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 3'b010;
        #1;

        check_outputs(16'h13B0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 3'b011;
        #1;

        check_outputs(16'h8980);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 3'b100;
        #1;

        check_outputs(16'h1500);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 3'b101;
        #1;

        check_outputs(16'hCC00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 3'b110;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 3'b111;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_w;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_w === (expected_w ^ w ^ expected_w)) begin
                $display("PASS");
                $display("  Outputs: w=%h",
                         w);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%h",
                         expected_w);
                $display("  Got:      w=%h",
                         w);
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
