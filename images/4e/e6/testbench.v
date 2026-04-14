`timescale 1ns/1ps

module mux_2to1_en_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg en;
    reg sel;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1_en dut (
        .a(a),
        .b(b),
        .en(en),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 4'h5;
            b = 4'hA;
            en = 0;
            sel = 0;
            $display("Test %0d: Enable=0, Sel=0. Expected y=0000", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 4'hF;
            b = 4'h3;
            en = 0;
            sel = 1;
            $display("Test %0d: Enable=0, Sel=1. Expected y=0000", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 4'hC;
            b = 4'h7;
            en = 1;
            sel = 0;
            $display("Test %0d: Enable=1, Sel=0. Expected y=a (%h)", test_num, a);
            #1;

            check_outputs(a);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 4'h1;
            b = 4'h9;
            en = 1;
            sel = 1;
            $display("Test %0d: Enable=1, Sel=1. Expected y=b (%h)", test_num, b);
            #1;

            check_outputs(b);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'b1010;
            b = 4'b0101;
            en = 1;
            sel = 0;
            $display("Test %0d: Enable=1, Sel=0. Expected y=a (%b)", test_num, a);
            #1;

            check_outputs(a);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 4'b1111;
            b = 4'b0000;
            en = 1;
            sel = 1;
            $display("Test %0d: Enable=1, Sel=1. Expected y=b (%b)", test_num, b);
            #1;

            check_outputs(b);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'hE;
            b = 4'hB;
            en = 0;
            sel = 1;
            $display("Test %0d: Enable Low Override. Expected y=0000", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1_en Testbench");
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
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
