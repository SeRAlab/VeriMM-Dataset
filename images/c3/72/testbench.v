`timescale 1ns/1ps

module full_subtractor_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg Bin;
    wire Bout;
    wire D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    full_subtractor dut (
        .A(A),
        .B(B),
        .Bin(Bin),
        .Bout(Bout),
        .D(D)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: A=0, B=0, Bin=0", test_num);
            A = 1'b0; B = 1'b0; Bin = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: A=0, B=0, Bin=1", test_num);
            A = 1'b0; B = 1'b0; Bin = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: A=0, B=1, Bin=0", test_num);
            A = 1'b0; B = 1'b1; Bin = 1'b0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: A=0, B=1, Bin=1", test_num);
            A = 1'b0; B = 1'b1; Bin = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: A=1, B=0, Bin=0", test_num);
            A = 1'b1; B = 1'b0; Bin = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: A=1, B=0, Bin=1", test_num);
            A = 1'b1; B = 1'b0; Bin = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: A=1, B=1, Bin=0", test_num);
            A = 1'b1; B = 1'b1; Bin = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: A=1, B=1, Bin=1", test_num);
            A = 1'b1; B = 1'b1; Bin = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("full_subtractor Testbench");
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
        input expected_Bout;
        input expected_D;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Bout === (expected_Bout ^ Bout ^ expected_Bout) &&
                expected_D === (expected_D ^ D ^ expected_D)) begin
                $display("PASS");
                $display("  Outputs: Bout=%b, D=%b",
                         Bout, D);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Bout=%b, D=%b",
                         expected_Bout, expected_D);
                $display("  Got:      Bout=%b, D=%b",
                         Bout, D);
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
