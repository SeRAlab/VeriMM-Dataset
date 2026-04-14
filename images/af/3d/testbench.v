`timescale 1ns/1ps

module state_transition_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] p;
    reg r;
    wire P2;
    wire P3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_transition dut (
        .p(p),
        .r(r),
        .P2(P2),
        .P3(P3)
    );
    task testcase001;

        begin
            test_num = 1;

            p = 4'b0000; r = 0; #5;


            p = 4'b0001; r = 0;
            $display("Test %0d: State G (p[1]=1), r=0. Expecting transition to H (P2=1, P3=0)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            p = 4'b0000; r = 0; #5;

            p = 4'b0001; r = 1;
            $display("Test %0d: State G (p[1]=1), r=1. Expecting transition to I (P2=0, P3=1)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            p = 4'b0000; r = 0; #5;

            p = 4'b0010; r = 0;
            $display("Test %0d: State H (p[2]=1), r=0. Expecting transition to G (P2=0, P3=0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            p = 4'b0000; r = 0; #5;

            p = 4'b0010; r = 1;
            $display("Test %0d: State H (p[2]=1), r=1. Expecting transition to J (P2=0, P3=0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            p = 4'b0000; r = 0; #5;

            p = 4'b0100; r = 0;
            $display("Test %0d: State I (p[3]=1), r=0. Expecting transition to J (P2=0, P3=0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            p = 4'b0000; r = 0; #5;

            p = 4'b0100; r = 1;
            $display("Test %0d: State I (p[3]=1), r=1. Expecting transition to G (P2=0, P3=0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            p = 4'b0000; r = 0; #5;

            p = 4'b1000; r = 0;
            $display("Test %0d: State J (p[4]=1), r=0. Expecting transition to H (P2=1, P3=0)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            p = 4'b0000; r = 0; #5;

            p = 4'b1000; r = 1;
            $display("Test %0d: State J (p[4]=1), r=1. Expecting transition to I (P2=0, P3=1)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            p = 4'b0000; r = 0; #5;

            p = 4'b1001; r = 0;
            $display("Test %0d: Multi-hot Input (G & J), r=0. Expecting H (P2=1, P3=0)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            p = 4'b0000; r = 0; #5;

            p = 4'b0000; r = 1;
            $display("Test %0d: Invalid Input (No states active), r=1. Expecting P2=0, P3=0", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("state_transition Testbench");
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
        testcase010();
        
        
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
        input expected_P2;
        input expected_P3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P2 === (expected_P2 ^ P2 ^ expected_P2) &&
                expected_P3 === (expected_P3 ^ P3 ^ expected_P3)) begin
                $display("PASS");
                $display("  Outputs: P2=%b, P3=%b",
                         P2, P3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P2=%b, P3=%b",
                         expected_P2, expected_P3);
                $display("  Got:      P2=%b, P3=%b",
                         P2, P3);
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
