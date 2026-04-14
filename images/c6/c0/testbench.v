`timescale 1ns/1ps

module max32_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    wire [31:0] out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    max32 dut (
        .in1(in1),
        .out1(out1)
    );
    task testcase001;

    begin
        $display("Running testcase001: Positive Value");
        test_num = test_num + 1;
        in1 = 32'd1500;
        #1;

        check_outputs(32'd1500);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Negative Value");
        test_num = test_num + 1;
        in1 = -32'd5000;
        #1;

        check_outputs(-32'd5000);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Zero");
        test_num = test_num + 1;
        in1 = 32'd0;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Maximum Signed 32-bit Integer");
        test_num = test_num + 1;
        in1 = 32'h7FFFFFFF;
        #1;

        check_outputs(32'h7FFFFFFF);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Minimum Signed 32-bit Integer");
        test_num = test_num + 1;
        in1 = 32'h80000000;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: All Ones (Signed -1)");
        test_num = test_num + 1;
        in1 = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Small Negative Value");
        test_num = test_num + 1;
        in1 = -32'd1;
        #1;

        check_outputs(-32'd1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("max32 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out1=%h",
                         out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h",
                         expected_out1);
                $display("  Got:      out1=%h",
                         out1);
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
