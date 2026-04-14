`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg m;
    wire [4:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .m(m),
        .s(s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 4'd0; b = 4'd0; m = 1'b0;
            $display("Test %0d: Addition (m=0), a=0, b=0", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 4'd7; b = 4'd8; m = 1'b0;
            $display("Test %0d: Addition (m=0), a=7, b=8", test_num);
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 4'd15; b = 4'd1; m = 1'b0;
            $display("Test %0d: Addition (m=0), a=15, b=1 (Carry check)", test_num);
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 4'd15; b = 4'd15; m = 1'b0;
            $display("Test %0d: Addition (m=0), a=15, b=15 (Max sum)", test_num);
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 4'd10; b = 4'd4; m = 1'b1;
            $display("Test %0d: Subtraction (m=1), a=10, b=4", test_num);
            #1;

            check_outputs(5'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 4'd15; b = 4'd15; m = 1'b1;
            $display("Test %0d: Subtraction (m=1), a=15, b=15", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 4'd5; b = 4'd10; m = 1'b1;
            $display("Test %0d: Subtraction (m=1), a=5, b=10 (Negative result)", test_num);

            #1;


            check_outputs(5'd27);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 4'd0; b = 4'd1; m = 1'b1;
            $display("Test %0d: Subtraction (m=1), a=0, b=1 (Negative result)", test_num);

            #1;


            check_outputs(5'd31);
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
        input [4:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%h",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h",
                         expected_s);
                $display("  Got:      s=%h",
                         s);
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
