`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cx0;
    reg cx1;
    wire [1:0] bm0;
    wire [1:0] bm1;
    wire [1:0] bm2;
    wire [1:0] bm3;
    wire [1:0] bm4;
    wire [1:0] bm5;
    wire [1:0] bm6;
    wire [1:0] bm7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cx0(cx0),
        .cx1(cx1),
        .bm0(bm0),
        .bm1(bm1),
        .bm2(bm2),
        .bm3(bm3),
        .bm4(bm4),
        .bm5(bm5),
        .bm6(bm6),
        .bm7(bm7)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Input cx1=0, cx0=0", test_num);
            cx1 = 1'b0;
            cx0 = 1'b0;



            #1;




            check_outputs(2'b00, 2'b00, 2'b00, 2'b00, 2'b00, 2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Input cx1=0, cx0=1", test_num);
            cx1 = 1'b0;
            cx0 = 1'b1;


            #1;



            check_outputs(2'b01, 2'b01, 2'b01, 2'b01, 2'b01, 2'b01, 2'b01, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Input cx1=1, cx0=0", test_num);
            cx1 = 1'b1;
            cx0 = 1'b0;


            #1;



            check_outputs(2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Input cx1=1, cx0=1", test_num);
            cx1 = 1'b1;
            cx0 = 1'b1;


            #1;



            check_outputs(2'b11, 2'b11, 2'b11, 2'b11, 2'b11, 2'b11, 2'b11, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Transition Stability Test", test_num);
            cx1 = 1'b1; cx0 = 1'b1;
            #5;
            cx1 = 1'b0; cx0 = 1'b0;


            #1;



            check_outputs(2'b00, 2'b00, 2'b00, 2'b00, 2'b00, 2'b00, 2'b00, 2'b00);
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
        input [1:0] expected_bm0;
        input [1:0] expected_bm1;
        input [1:0] expected_bm2;
        input [1:0] expected_bm3;
        input [1:0] expected_bm4;
        input [1:0] expected_bm5;
        input [1:0] expected_bm6;
        input [1:0] expected_bm7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bm0 === (expected_bm0 ^ bm0 ^ expected_bm0) &&
                expected_bm1 === (expected_bm1 ^ bm1 ^ expected_bm1) &&
                expected_bm2 === (expected_bm2 ^ bm2 ^ expected_bm2) &&
                expected_bm3 === (expected_bm3 ^ bm3 ^ expected_bm3) &&
                expected_bm4 === (expected_bm4 ^ bm4 ^ expected_bm4) &&
                expected_bm5 === (expected_bm5 ^ bm5 ^ expected_bm5) &&
                expected_bm6 === (expected_bm6 ^ bm6 ^ expected_bm6) &&
                expected_bm7 === (expected_bm7 ^ bm7 ^ expected_bm7)) begin
                $display("PASS");
                $display("  Outputs: bm0=%h, bm1=%h, bm2=%h, bm3=%h, bm4=%h, bm5=%h, bm6=%h, bm7=%h",
                         bm0, bm1, bm2, bm3, bm4, bm5, bm6, bm7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bm0=%h, bm1=%h, bm2=%h, bm3=%h, bm4=%h, bm5=%h, bm6=%h, bm7=%h",
                         expected_bm0, expected_bm1, expected_bm2, expected_bm3, expected_bm4, expected_bm5, expected_bm6, expected_bm7);
                $display("  Got:      bm0=%h, bm1=%h, bm2=%h, bm3=%h, bm4=%h, bm5=%h, bm6=%h, bm7=%h",
                         bm0, bm1, bm2, bm3, bm4, bm5, bm6, bm7);
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
