`timescale 1ns/1ps

module mux_2to1_with_forwarding_tb;

    // Testbench signals (combinational circuit)
    reg forward;
    reg [3:0] in0;
    reg [3:0] in1;
    reg sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1_with_forwarding dut (
        .forward(forward),
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            forward = 1'b0;
            sel = 1'b0;
            in0 = 4'hA;
            in1 = 4'h5;
            $display("Test %03d: Normal Mux - sel=0, forward=0. Expect in1 (4'h5)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            forward = 1'b0;
            sel = 1'b1;
            in0 = 4'hC;
            in1 = 4'h3;
            $display("Test %03d: Normal Mux - sel=1, forward=0. Expect in0 (4'hC)", test_num);
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            forward = 1'b1;
            sel = 1'b0;
            in0 = 4'h7;
            in1 = 4'hE;
            $display("Test %03d: Forwarding Active - forward=1, sel=0. Expect in0 (4'h7)", test_num);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            forward = 1'b1;
            sel = 1'b1;
            in0 = 4'hF;
            in1 = 4'h0;
            $display("Test %03d: Forwarding Active - forward=1, sel=1. Expect in0 (4'hF)", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            forward = 1'b0;
            sel = 1'b0;
            in0 = 4'h0;
            in1 = 4'h0;
            $display("Test %03d: All Zeros Data. Expect 4'h0", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            forward = 1'b0;
            sel = 1'b1;
            in0 = 4'hF;
            in1 = 4'hF;
            $display("Test %03d: All Ones Data. Expect 4'hF", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            forward = 1'b0;
            sel = 1'b0;
            in0 = 4'b1010;
            in1 = 4'b0101;
            $display("Test %03d: Alternating Bits - sel=0. Expect 4'b0101 (5)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in0 = 4'h1;
            in1 = 4'h2;
            forward = 1'b0;
            sel = 1'b1;
            #1;
            sel = 1'b0;
            $display("Test %03d: Rapid Toggle - Final state sel=0. Expect 4'h2", test_num);
            #1;

            check_outputs(4'h2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1_with_forwarding Testbench");
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
        input [3:0] expected_out;
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
