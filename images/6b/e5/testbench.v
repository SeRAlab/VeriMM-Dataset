`timescale 1ns/1ps

module mux_5to1_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] in0;
    reg [9:0] in1;
    reg [9:0] in2;
    reg [9:0] in3;
    reg [9:0] in4;
    reg [2:0] sel;
    wire [9:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_5to1 dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        in0 = 10'h123; in1 = 10'h000; in2 = 10'h000; in3 = 10'h000; in4 = 10'h000;
        sel = 3'd0;
        $display("Test %0d: Select in0 with value 10'h123", test_num);
        #1;

        check_outputs(10'h123);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in0 = 10'h000; in1 = 10'h3FF; in2 = 10'h000; in3 = 10'h000; in4 = 10'h000;
        sel = 3'd1;
        $display("Test %0d: Select in1 with value 10'h3FF", test_num);
        #1;

        check_outputs(10'h3FF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in0 = 10'h000; in1 = 10'h000; in2 = 10'h2AA; in3 = 10'h000; in4 = 10'h000;
        sel = 3'd2;
        $display("Test %0d: Select in2 with value 10'h2AA", test_num);
        #1;

        check_outputs(10'h2AA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in0 = 10'h000; in1 = 10'h000; in2 = 10'h000; in3 = 10'h155; in4 = 10'h000;
        sel = 3'd3;
        $display("Test %0d: Select in3 with value 10'h155", test_num);
        #1;

        check_outputs(10'h155);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in0 = 10'h000; in1 = 10'h000; in2 = 10'h000; in3 = 10'h000; in4 = 10'h055;
        sel = 3'd4;
        $display("Test %0d: Select in4 with value 10'h055", test_num);
        #1;

        check_outputs(10'h055);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in0 = 10'h111; in1 = 10'h222; in2 = 10'h333; in3 = 10'h123; in4 = 10'h045;
        sel = 3'd5;
        $display("Test %0d: Select invalid index (sel=5)", test_num);

        #1;


        check_outputs(10'h000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in0 = 10'h001; in1 = 10'h002; in2 = 10'h003; in3 = 10'h004; in4 = 10'h005;
        sel = 3'd3;
        #5;
        in3 = 10'h3FF;
        $display("Test %0d: Check if output updates when input data changes", test_num);
        #1;

        check_outputs(10'h3FF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_5to1 Testbench");
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
        input [9:0] expected_out;
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
