`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d0;
    reg [7:0] d1;
    reg [7:0] d2;
    reg [7:0] d3;
    reg s0;
    reg s1;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .s0(s0),
        .s1(s1),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select d0 (s1=0, s0=0)", test_num);
            d0 = 8'hA5;
            d1 = 8'h00;
            d2 = 8'h00;
            d3 = 8'h00;
            s1 = 1'b0;
            s0 = 1'b0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select d1 (s1=0, s0=1)", test_num);
            d0 = 8'h00;
            d1 = 8'h5A;
            d2 = 8'h00;
            d3 = 8'h00;
            s1 = 1'b0;
            s0 = 1'b1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select d2 (s1=1, s0=0)", test_num);
            d0 = 8'h00;
            d1 = 8'h00;
            d2 = 8'hF0;
            d3 = 8'h00;
            s1 = 1'b1;
            s0 = 1'b0;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select d3 (s1=1, s0=1)", test_num);
            d0 = 8'h00;
            d1 = 8'h00;
            d2 = 8'h00;
            d3 = 8'h0F;
            s1 = 1'b1;
            s0 = 1'b1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Verify all inputs with different values (Select d1)", test_num);
            d0 = 8'h11;
            d1 = 8'h22;
            d2 = 8'h33;
            d3 = 8'h44;
            s1 = 1'b0;
            s0 = 1'b1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Boundary values - All inputs FF (Select d2)", test_num);
            d0 = 8'hFF;
            d1 = 8'hFF;
            d2 = 8'hFF;
            d3 = 8'hFF;
            s1 = 1'b1;
            s0 = 1'b0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Boundary values - All inputs 00 (Select d3)", test_num);
            d0 = 8'h00;
            d1 = 8'h00;
            d2 = 8'h00;
            d3 = 8'h00;
            s1 = 1'b1;
            s0 = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Changing data input while selected (Select d0)", test_num);
            s1 = 1'b0;
            s0 = 1'b0;
            d0 = 8'h12;
            #5;
            d0 = 8'h34;
            #1;

            check_outputs(8'h34);
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
