`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg l0;
    reg l1;
    reg l2;
    reg l3;
    reg l4;
    reg l5;
    reg l6;
    reg [7:0] v0;
    reg [7:0] v1;
    reg [7:0] v2;
    reg [7:0] v3;
    reg [7:0] v4;
    reg [7:0] v5;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .l0(l0),
        .l1(l1),
        .l2(l2),
        .l3(l3),
        .l4(l4),
        .l5(l5),
        .l6(l6),
        .v0(v0),
        .v1(v1),
        .v2(v2),
        .v3(v3),
        .v4(v4),
        .v5(v5),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select v0 (l0=1)", test_num);
            v0 = 8'hA5; v1 = 8'h5A; v2 = 8'h11; v3 = 8'h22; v4 = 8'h33; v5 = 8'h44;
            l0 = 1; l1 = 0; l2 = 0; l3 = 0; l4 = 0; l5 = 0; l6 = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select v1 (l1=1)", test_num);
            v0 = 8'hA5; v1 = 8'h5A; v2 = 8'h11; v3 = 8'h22; v4 = 8'h33; v5 = 8'h44;
            l0 = 0; l1 = 1; l2 = 0; l3 = 0; l4 = 0; l5 = 0; l6 = 0;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select v2 (l2=1)", test_num);
            v0 = 8'hA5; v1 = 8'h5A; v2 = 8'h11; v3 = 8'h22; v4 = 8'h33; v5 = 8'h44;
            l0 = 0; l1 = 0; l2 = 1; l3 = 0; l4 = 0; l5 = 0; l6 = 0;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select v3 (l3=1)", test_num);
            v0 = 8'hA5; v1 = 8'h5A; v2 = 8'h11; v3 = 8'h22; v4 = 8'h33; v5 = 8'h44;
            l0 = 0; l1 = 0; l2 = 0; l3 = 1; l4 = 0; l5 = 0; l6 = 0;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select v4 (l4=1)", test_num);
            v0 = 8'hA5; v1 = 8'h5A; v2 = 8'h11; v3 = 8'h22; v4 = 8'h33; v5 = 8'h44;
            l0 = 0; l1 = 0; l2 = 0; l3 = 0; l4 = 1; l5 = 0; l6 = 0;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select v5 (l5=1)", test_num);
            v0 = 8'hA5; v1 = 8'h5A; v2 = 8'h11; v3 = 8'h22; v4 = 8'h33; v5 = 8'h44;
            l0 = 0; l1 = 0; l2 = 0; l3 = 0; l4 = 0; l5 = 1; l6 = 0;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Replication of v0[7] (l6=1, v0[7]=1)", test_num);
            v0 = 8'hA5;
            l0 = 0; l1 = 0; l2 = 0; l3 = 0; l4 = 0; l5 = 0; l6 = 1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Replication of v0[7] (l6=1, v0[7]=0)", test_num);
            v0 = 8'h25;
            l0 = 0; l1 = 0; l2 = 0; l3 = 0; l4 = 0; l5 = 0; l6 = 1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No selection active (Default state)", test_num);
            l0 = 0; l1 = 0; l2 = 0; l3 = 0; l4 = 0; l5 = 0; l6 = 0;

            #1;


            check_outputs(8'h00);
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
