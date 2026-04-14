`timescale 1ns/1ps

module mux_6to1_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] in0;
    reg [11:0] in1;
    reg [11:0] in2;
    reg [11:0] in3;
    reg [11:0] in4;
    reg [11:0] in5;
    reg [2:0] sel;
    wire [11:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_6to1 dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select in0", test_num);
            in0 = 12'hAAA; in1 = 12'h001; in2 = 12'h002;
            in3 = 12'h003; in4 = 12'h004; in5 = 12'h005;
            sel = 3'd0;
            #1;

            check_outputs(12'hAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select in1", test_num);
            in0 = 12'h000; in1 = 12'hBBB; in2 = 12'h002;
            in3 = 12'h003; in4 = 12'h004; in5 = 12'h005;
            sel = 3'd1;
            #1;

            check_outputs(12'hBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select in2", test_num);
            in0 = 12'h000; in1 = 12'h001; in2 = 12'hCCC;
            in3 = 12'h003; in4 = 12'h004; in5 = 12'h005;
            sel = 3'd2;
            #1;

            check_outputs(12'hCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select in3", test_num);
            in0 = 12'h000; in1 = 12'h001; in2 = 12'h002;
            in3 = 12'hDDD; in4 = 12'h004; in5 = 12'h005;
            sel = 3'd3;
            #1;

            check_outputs(12'hDDD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select in4", test_num);
            in0 = 12'h000; in1 = 12'h001; in2 = 12'h002;
            in3 = 12'h003; in4 = 12'hEEE; in5 = 12'h005;
            sel = 3'd4;
            #1;

            check_outputs(12'hEEE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select in5", test_num);
            in0 = 12'h000; in1 = 12'h001; in2 = 12'h002;
            in3 = 12'h003; in4 = 12'h004; in5 = 12'hFFF;
            sel = 3'd5;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Verify data change on active selection (in3)", test_num);
            in0 = 12'h111; in1 = 12'h222; in2 = 12'h333;
            in3 = 12'h444; in4 = 12'h555; in5 = 12'h666;
            sel = 3'd3;
            #5;
            in3 = 12'hABC;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Verify all-zeros input on in0", test_num);
            in0 = 12'h000; in1 = 12'hFFF; in2 = 12'hFFF;
            in3 = 12'hFFF; in4 = 12'hFFF; in5 = 12'hFFF;
            sel = 3'd0;
            #1;

            check_outputs(12'h000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_6to1 Testbench");
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
        input [11:0] expected_out;
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
