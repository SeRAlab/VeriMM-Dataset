`timescale 1ns/1ps

module BOTTOM_MUX_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    reg sel;
    wire [4:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BOTTOM_MUX dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select A (sel=1)", test_num);
            a = 5'b10101;
            b = 5'b01010;
            sel = 1'b1;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select B (sel=0)", test_num);
            a = 5'b10101;
            b = 5'b01010;
            sel = 1'b0;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All ones on A, sel=1", test_num);
            a = 5'b11111;
            b = 5'b00000;
            sel = 1'b1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: All ones on B, sel=0", test_num);
            a = 5'b00000;
            b = 5'b11111;
            sel = 1'b0;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Boundary values, sel=1", test_num);
            a = 5'h1F;
            b = 5'h10;
            sel = 1'b1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Boundary values, sel=0", test_num);
            a = 5'h1F;
            b = 5'h10;
            sel = 1'b0;
            #1;

            check_outputs(5'h10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Zero inputs, sel=1", test_num);
            a = 5'h00;
            b = 5'h1A;
            sel = 1'b1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Change select on same inputs", test_num);
            a = 5'h0F;
            b = 5'h0F;
            sel = 1'b0;
            #1;

            check_outputs(5'h0F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BOTTOM_MUX Testbench");
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
        input [4:0] expected_y;
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
