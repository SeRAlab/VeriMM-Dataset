`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] gin;
    wire [31:0] sum;
    wire zout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .gin(gin),
        .sum(sum),
        .zout(zout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Bitwise AND (gin=0000)", test_num);
            gin = 4'b0000;
            a = 32'hF0F0F0F0;
            b = 32'hFFFF0000;

            #1;


            check_outputs(32'hF0F00000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Bitwise AND Resulting in Zero", test_num);
            gin = 4'b0000;
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Bitwise OR (gin=0001)", test_num);
            gin = 4'b0001;
            a = 32'h1234_0000;
            b = 32'h0000_5678;

            #1;


            check_outputs(32'h1234_5678, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Addition (gin=0010)", test_num);
            gin = 4'b0010;
            a = 32'd150;
            b = 32'd350;

            #1;


            check_outputs(32'd500, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Addition Wrap-around to Zero", test_num);
            gin = 4'b0010;
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0001;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Subtraction (gin=0110)", test_num);
            gin = 4'b0110;
            a = 32'd1000;
            b = 32'd400;

            #1;


            check_outputs(32'd600, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Subtraction Resulting in Zero", test_num);
            gin = 4'b0110;
            a = 32'hDEAD_BEEF;
            b = 32'hDEAD_BEEF;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: SLT True (gin=0111)", test_num);
            gin = 4'b0111;
            a = 32'd10;
            b = 32'd20;

            #1;


            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: SLT False (Result 0)", test_num);
            gin = 4'b0111;
            a = 32'd20;
            b = 32'd10;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Bitwise NOR (gin=1100)", test_num);
            gin = 4'b1100;
            a = 32'h0000_0000;
            b = 32'h0000_0000;

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Bitwise NOR Resulting in Zero", test_num);
            gin = 4'b1100;
            a = 32'hFFFF_0000;
            b = 32'h0000_FFFF;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %0d: SLT Signed Comparison Check", test_num);
            gin = 4'b0111;
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0001;

            #1;


            check_outputs(32'h0000_0001, 1'b0);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [31:0] expected_sum;
        input expected_zout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum) &&
                expected_zout === (expected_zout ^ zout ^ expected_zout)) begin
                $display("PASS");
                $display("  Outputs: sum=%h, zout=%b",
                         sum, zout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h, zout=%b",
                         expected_sum, expected_zout);
                $display("  Got:      sum=%h, zout=%b",
                         sum, zout);
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
