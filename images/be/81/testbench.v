`timescale 1ns/1ps

module binary_subtractor_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg bin;
    wire bout;
    wire [7:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_subtractor dut (
        .a(a),
        .b(b),
        .bin(bin),
        .bout(bout),
        .diff(diff)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple subtraction (10 - 5)", test_num);
            a = 8'd10;
            b = 8'd5;
            bin = 1'b0;
            #1;

            check_outputs(1'b0, 8'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction resulting in zero (10 - 10)", test_num);
            a = 8'd10;
            b = 8'd10;
            bin = 1'b0;
            #1;

            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction with borrow-out (5 - 10)", test_num);
            a = 8'd5;
            b = 8'd10;
            bin = 1'b0;

            #1;


            check_outputs(1'b1, 8'hFB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction with borrow-in (10 - 5 - 1)", test_num);
            a = 8'd10;
            b = 8'd5;
            bin = 1'b1;
            #1;

            check_outputs(1'b0, 8'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero minus borrow-in (0 - 0 - 1)", test_num);
            a = 8'd0;
            b = 8'd0;
            bin = 1'b1;

            #1;


            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max values (255 - 255)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            bin = 1'b0;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max values with borrow-in (255 - 255 - 1)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            bin = 1'b1;

            #1;


            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Smallest minuend, largest subtrahend (0 - 255)", test_num);
            a = 8'h00;
            b = 8'hFF;
            bin = 1'b0;

            #1;


            check_outputs(1'b1, 8'h01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits (0xAA - 0x55)", test_num);
            a = 8'hAA;
            b = 8'h55;
            bin = 1'b0;
            #1;

            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary crossing (0x80 - 0x7F - 1)", test_num);
            a = 8'h80;
            b = 8'h7F;
            bin = 1'b1;

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_subtractor Testbench");
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
        input expected_bout;
        input [7:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bout === (expected_bout ^ bout ^ expected_bout) &&
                expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: bout=%b, diff=%h",
                         bout, diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bout=%b, diff=%h",
                         expected_bout, expected_diff);
                $display("  Got:      bout=%b, diff=%h",
                         bout, diff);
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
