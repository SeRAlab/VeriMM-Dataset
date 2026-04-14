`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] y0;
    reg [31:0] y1;
    reg [31:0] y2;
    reg [31:0] y3;
    wire [31:0] z0;
    wire [31:0] z1;
    wire [31:0] z2;
    wire [31:0] z3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .z0(z0),
        .z1(z1),
        .z2(z2),
        .z3(z3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            y0 = 32'h0;
            y1 = 32'h0;
            y2 = 32'h0;
            y3 = 32'h0;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: RFC 8439 Standard Vector", test_num);
            y0 = 32'h11111111;
            y1 = 32'h01020304;
            y2 = 32'h9b8d6f43;
            y3 = 32'h01234567;





            #1;






            check_outputs(32'hea2a92f4, 32'hcb1cf8ce, 32'h4581472e, 32'h5881c4bb);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Propagation (y0=1)", test_num);
            y0 = 32'h00000001;
            y1 = 32'h00000000;
            y2 = 32'h00000000;
            y3 = 32'h00000000;





            #1;






            check_outputs(32'h10000001, 32'h88080888, 32'h01010110, 32'h01000110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry and Overflow (y0=0xFFFFFFFF)", test_num);
            y0 = 32'hffffffff;
            y1 = 32'h00000000;
            y2 = 32'h00000000;
            y3 = 32'h00000000;





            #1;






            check_outputs(32'hfffffffe, 32'hff80007f, 32'h000000ff, 32'h00000100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            y0 = 32'hffffffff;
            y1 = 32'hffffffff;
            y2 = 32'hffffffff;
            y3 = 32'hffffffff;





            #1;






            check_outputs(32'hefff0ffd, 32'h08790888, 32'he010fdee, 32'he00ffdef);
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
        input [31:0] expected_z0;
        input [31:0] expected_z1;
        input [31:0] expected_z2;
        input [31:0] expected_z3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z0 === (expected_z0 ^ z0 ^ expected_z0) &&
                expected_z1 === (expected_z1 ^ z1 ^ expected_z1) &&
                expected_z2 === (expected_z2 ^ z2 ^ expected_z2) &&
                expected_z3 === (expected_z3 ^ z3 ^ expected_z3)) begin
                $display("PASS");
                $display("  Outputs: z0=%h, z1=%h, z2=%h, z3=%h",
                         z0, z1, z2, z3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z0=%h, z1=%h, z2=%h, z3=%h",
                         expected_z0, expected_z1, expected_z2, expected_z3);
                $display("  Got:      z0=%h, z1=%h, z2=%h, z3=%h",
                         z0, z1, z2, z3);
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
