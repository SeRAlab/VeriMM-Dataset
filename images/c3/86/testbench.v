`timescale 1ns/1ps

module mux4_tb;

    // Testbench signals (combinational circuit)
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg sel0;
    reg sel1;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4 dut (
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
            test_num = test_num + 1;
            $display("Test Case %0d: Select in0, in0=0", test_num);
            sel1 = 0; sel0 = 0;
            in0 = 0; in1 = 1; in2 = 1; in3 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in0, in0=1", test_num);
            sel1 = 0; sel0 = 0;
            in0 = 1; in1 = 0; in2 = 0; in3 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1, in1=0", test_num);
            sel1 = 0; sel0 = 1;
            in0 = 1; in1 = 0; in2 = 1; in3 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1, in1=1", test_num);
            sel1 = 0; sel0 = 1;
            in0 = 0; in1 = 1; in2 = 0; in3 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2, in2=0", test_num);
            sel1 = 1; sel0 = 0;
            in0 = 1; in1 = 1; in2 = 0; in3 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2, in2=1", test_num);
            sel1 = 1; sel0 = 0;
            in0 = 0; in1 = 0; in2 = 1; in3 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in3, in3=0", test_num);
            sel1 = 1; sel0 = 1;
            in0 = 1; in1 = 1; in2 = 1; in3 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in3, in3=1", test_num);
            sel1 = 1; sel0 = 1;
            in0 = 0; in1 = 0; in2 = 0; in3 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Path independence (change in1 while in0 is selected)", test_num);
            sel1 = 0; sel0 = 0;
            in0 = 1; in1 = 1; in2 = 0; in3 = 0;
            #1;
            in1 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4 Testbench");
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
