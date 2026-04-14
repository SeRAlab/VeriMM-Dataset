`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] vra;
    reg [31:0] vrb;
    wire sat;
    wire [31:0] vrt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vra(vra),
        .vrb(vrb),
        .sat(sat),
        .vrt(vrt)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Positive addition (No Overflow)", test_num);
            vra = 32'd100;
            vrb = 32'd250;
            #1;

            check_outputs(1'b0, 32'd350);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Negative addition (No Overflow)", test_num);
            vra = -32'd500;
            vrb = -32'd1000;
            #1;

            check_outputs(1'b0, -32'd1500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Mixed signs", test_num);
            vra = 32'd5000;
            vrb = -32'd2000;
            #1;

            check_outputs(1'b0, 32'd3000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Positive Saturation (Max Positive)", test_num);
            vra = 32'h7FFFFFFF;
            vrb = 32'd1;
            #1;

            check_outputs(1'b1, 32'h7FFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Negative Saturation (Max Negative)", test_num);
            vra = 32'h80000000;
            vrb = -32'd1;
            #1;

            check_outputs(1'b1, 32'h80000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Large Positive addition (Just below threshold)", test_num);
            vra = 32'h3FFFFFFF;
            vrb = 32'h3FFFFFFF;
            #1;

            check_outputs(1'b0, 32'h7FFFFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Large Negative addition (Exact limit)", test_num);
            vra = 32'hC0000000;
            vrb = 32'hC0000000;
            #1;

            check_outputs(1'b0, 32'h80000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Zero addition", test_num);
            vra = 32'h00000000;
            vrb = 32'h00000000;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Max positive overflow with two large values", test_num);
            vra = 32'h70000000;
            vrb = 32'h10000000;
            #1;

            check_outputs(1'b1, 32'h7FFFFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Max negative overflow with two large values", test_num);
            vra = 32'hB0000000;
            vrb = 32'hC0000000;
            #1;

            check_outputs(1'b1, 32'h80000000);
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
        input expected_sat;
        input [31:0] expected_vrt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sat === (expected_sat ^ sat ^ expected_sat) &&
                expected_vrt === (expected_vrt ^ vrt ^ expected_vrt)) begin
                $display("PASS");
                $display("  Outputs: sat=%b, vrt=%h",
                         sat, vrt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sat=%b, vrt=%h",
                         expected_sat, expected_vrt);
                $display("  Got:      sat=%b, vrt=%h",
                         sat, vrt);
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
