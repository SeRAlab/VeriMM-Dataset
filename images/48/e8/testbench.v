`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] array1;
    reg [255:0] array2;
    wire [31:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .array1(array1),
        .array2(array2),
        .res(res)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            array1 = 256'h0;
            array2 = 256'h0;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single segment multiplication (Low)", test_num);
            array1 = 256'h0;
            array2 = 256'h0;
            array1[31:0] = 32'd10;
            array2[31:0] = 32'd5;

            #1;


            check_outputs(32'h32);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All segments equal", test_num);


            array1 = {8{32'd2}};
            array2 = {8{32'd3}};
            #1;

            check_outputs(32'h30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Segment multiplication overflow (32-bit truncation)", test_num);
            array1 = 256'h0;
            array2 = 256'h0;

            array1[63:32] = 32'h00010000;
            array2[63:32] = 32'h00010000;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Summation overflow (32-bit truncation)", test_num);


            array1 = {8{32'hFFFFFFFF}};
            array2 = {8{32'h00000001}};
            #1;

            check_outputs(32'hFFFFFFF8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum segment values", test_num);



            array1 = {8{32'hFFFFFFFF}};
            array2 = {8{32'hFFFFFFFF}};
            #1;

            check_outputs(32'h00000008);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High-order segment check", test_num);
            array1 = 256'h0;
            array2 = 256'h0;

            array1[255:224] = 32'd7;
            array2[255:224] = 32'd9;

            #1;


            check_outputs(32'h3F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed segments", test_num);
            array1 = {32'd1, 32'd2, 32'd3, 32'd4, 32'd5, 32'd6, 32'd7, 32'd8};
            array2 = {8{32'd1}};

            #1;


            check_outputs(32'h24);
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
        input [31:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
