`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] in;
    reg [7:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select index 0 (Expected: 1)", test_num);
            in = 256'b0;
            in[0] = 1'b1;
            sel = 8'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select index 255 (Expected: 1)", test_num);
            in = 256'b0;
            in[255] = 1'b1;
            sel = 8'd255;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select index 128 (Expected: 0)", test_num);
            in = {256{1'b1}};
            in[128] = 1'b0;
            sel = 8'd128;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating pattern, select index 5 (Expected: 1)", test_num);
            for (i = 0; i < 256; i = i + 1) begin
                in[i] = (i % 2 == 1);
            end
            sel = 8'd5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating pattern, select index 10 (Expected: 0)", test_num);
            for (i = 0; i < 256; i = i + 1) begin
                in[i] = (i % 2 == 1);
            end
            sel = 8'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select index 64 (Expected: 1)", test_num);
            in = 256'b0;
            in[64] = 1'b1;
            sel = 8'd64;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select index 192 (Expected: 0)", test_num);
            in = {256{1'b1}};
            in[192] = 1'b0;
            sel = 8'd192;
            #1;

            check_outputs(1'b0);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
