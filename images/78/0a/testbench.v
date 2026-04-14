`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [1:0] sel;
    wire [7:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .mux_out(mux_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in0 (sel=2'b00)", test_num);
            in0 = 8'hA5; in1 = 8'h5A; in2 = 8'hFF; in3 = 8'h00;
            sel = 2'b00;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in1 (sel=2'b01)", test_num);
            in0 = 8'h11; in1 = 8'h22; in2 = 8'h33; in3 = 8'h44;
            sel = 2'b01;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in2 (sel=2'b10)", test_num);
            in0 = 8'hDE; in1 = 8'hAD; in2 = 8'hBE; in3 = 8'hEF;
            sel = 2'b10;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in3 (sel=2'b11)", test_num);
            in0 = 8'h00; in1 = 8'h10; in2 = 8'h20; in3 = 8'h30;
            sel = 2'b11;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs identical", test_num);
            in0 = 8'hCC; in1 = 8'hCC; in2 = 8'hCC; in3 = 8'hCC;
            sel = 2'b01;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dynamic input change check", test_num);
            in0 = 8'h00; in1 = 8'h77; in2 = 8'h00; in3 = 8'h00;
            sel = 2'b01;
            #2;
            in1 = 8'h88;
            #1;

            check_outputs(8'h88);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary values (All 1s)", test_num);
            in0 = 8'hFF; in1 = 8'hFF; in2 = 8'hFF; in3 = 8'hFF;
            sel = 2'b11;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%h",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%h",
                         expected_mux_out);
                $display("  Got:      mux_out=%h",
                         mux_out);
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
