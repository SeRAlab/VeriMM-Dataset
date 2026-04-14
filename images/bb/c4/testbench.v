`timescale 1ns/1ps

module mux2to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg sel;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1 dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select Input A (sel=0)", test_num);
            a = 4'hA;
            b = 4'h5;
            sel = 1'b0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select Input B (sel=1)", test_num);
            a = 4'hA;
            b = 4'h5;
            sel = 1'b1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All Zeros on Input A, Select A", test_num);
            a = 4'b0000;
            b = 4'b1111;
            sel = 1'b0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: All Ones on Input B, Select B", test_num);
            a = 4'b0000;
            b = 4'b1111;
            sel = 1'b1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Alternating Bits - Select A", test_num);
            a = 4'b1100;
            b = 4'b0011;
            sel = 1'b0;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Alternating Bits - Select B", test_num);
            a = 4'b1100;
            b = 4'b0011;
            sel = 1'b1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Prime-like pattern - Select A", test_num);
            a = 4'h7;
            b = 4'hD;
            sel = 1'b0;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Prime-like pattern - Select B", test_num);
            a = 4'h7;
            b = 4'hD;
            sel = 1'b1;
            #1;

            check_outputs(4'hD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2to1 Testbench");
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
