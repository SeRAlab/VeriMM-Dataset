`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [3:0] in4;
    reg sel1;
    reg sel2;
    wire [3:0] out_always;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .sel1(sel1),
        .sel2(sel2),
        .out_always(out_always)
    );
    task testcase001;

        begin
            test_num = 1;
            in1 = 4'hA; in2 = 4'h0; in3 = 4'h0; in4 = 4'h0;
            sel1 = 1'b0; sel2 = 1'b0;
            #5;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in1 = 4'h0; in2 = 4'hB; in3 = 4'h0; in4 = 4'h0;
            sel1 = 1'b0; sel2 = 1'b1;
            #5;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in1 = 4'h0; in2 = 4'h0; in3 = 4'hC; in4 = 4'h0;
            sel1 = 1'b1; sel2 = 1'b0;
            #5;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in1 = 4'h0; in2 = 4'h0; in3 = 4'h0; in4 = 4'hD;
            sel1 = 1'b1; sel2 = 1'b1;
            #5;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in1 = 4'h5; in2 = 4'h6; in3 = 4'h7; in4 = 4'h8;
            sel1 = 1'b0; sel2 = 1'b1;
            #5;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in1 = 4'hF; in2 = 4'hE; in3 = 4'hD; in4 = 4'hC;
            sel1 = 1'b1; sel2 = 1'b1;
            #5;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in1 = 4'h3; in2 = 4'h3; in3 = 4'h3; in4 = 4'h3;
            sel1 = 1'b1; sel2 = 1'b0;
            #5;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in1 = 4'h0; in2 = 4'hF; in3 = 4'hA; in4 = 4'h5;
            sel1 = 1'b0; sel2 = 1'b0;
            #5;
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
        input [3:0] expected_out_always;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_always === (expected_out_always ^ out_always ^ expected_out_always)) begin
                $display("PASS");
                $display("  Outputs: out_always=%h",
                         out_always);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_always=%h",
                         expected_out_always);
                $display("  Got:      out_always=%h",
                         out_always);
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
