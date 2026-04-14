`timescale 1ns/1ps

module mux_4to1_case_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg sel0;
    reg sel1;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1_case dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel0(sel0),
        .sel1(sel1),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in0 = 4'hA; in1 = 4'h5; in2 = 4'h0; in3 = 4'hF;
            sel0 = 0; sel1 = 0;
            $display("Test %0d: Select in0 (sel0=0, sel1=0)", test_num);
            #1;

            check_outputs(in0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in0 = 4'hA; in1 = 4'h5; in2 = 4'h0; in3 = 4'hF;
            sel0 = 0; sel1 = 1;
            $display("Test %0d: Select in1 (sel0=0, sel1=1)", test_num);
            #1;

            check_outputs(in1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in0 = 4'hA; in1 = 4'h5; in2 = 4'h0; in3 = 4'hF;
            sel0 = 1; sel1 = 0;
            $display("Test %0d: Select in2 (sel0=1, sel1=0)", test_num);
            #1;

            check_outputs(in2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in0 = 4'hA; in1 = 4'h5; in2 = 4'h0; in3 = 4'hF;
            sel0 = 1; sel1 = 1;
            $display("Test %0d: Select in3 (sel0=1, sel1=1)", test_num);
            #1;

            check_outputs(in3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in0 = 4'h1; in1 = 4'h2; in2 = 4'h4; in3 = 4'h8;
            sel0 = 0; sel1 = 0;
            $display("Test %0d: Select in0 with new data (sel0=0, sel1=0)", test_num);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in0 = 4'hE; in1 = 4'hD; in2 = 4'hC; in3 = 4'hB;
            sel0 = 1; sel1 = 1;
            $display("Test %0d: Select in3 with new data (sel0=1, sel1=1)", test_num);
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in0 = 4'h0; in1 = 4'h0; in2 = 4'h0; in3 = 4'h0;
            sel0 = 1; sel1 = 0;
            $display("Test %0d: All inputs zero, select in2", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in0 = 4'hF; in1 = 4'hF; in2 = 4'hF; in3 = 4'hF;
            sel0 = 0; sel1 = 1;
            $display("Test %0d: All inputs high, select in1", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1_case Testbench");
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
