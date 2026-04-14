`timescale 1ns/1ps

module combinational_logic_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg B1;
    reg B2;
    reg C1;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    combinational_logic dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .C1(C1),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=0, B1=0, B2=0, C1=0", test_num);
            A1 = 0; A2 = 0; B1 = 0; B2 = 0; C1 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=0, B1=0, B2=0, C1=1", test_num);
            A1 = 0; A2 = 0; B1 = 0; B2 = 0; C1 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=0, B1=0, B2=1, C1=0", test_num);
            A1 = 0; A2 = 0; B1 = 0; B2 = 1; C1 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=0, B1=0, B2=1, C1=1", test_num);
            A1 = 0; A2 = 0; B1 = 0; B2 = 1; C1 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=0, B1=1, B2=0, C1=0", test_num);
            A1 = 0; A2 = 0; B1 = 1; B2 = 0; C1 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=0, B1=1, B2=0, C1=1", test_num);
            A1 = 0; A2 = 0; B1 = 1; B2 = 0; C1 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=0, B1=1, B2=1, C1=0", test_num);
            A1 = 0; A2 = 0; B1 = 1; B2 = 1; C1 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=0, B1=1, B2=1, C1=1", test_num);
            A1 = 0; A2 = 0; B1 = 1; B2 = 1; C1 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=1, B1=0, B2=0, C1=0", test_num);
            A1 = 0; A2 = 1; B1 = 0; B2 = 0; C1 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=1, B1=0, B2=0, C1=1", test_num);
            A1 = 0; A2 = 1; B1 = 0; B2 = 0; C1 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=1, B1=0, B2=1, C1=0", test_num);
            A1 = 0; A2 = 1; B1 = 0; B2 = 1; C1 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=1, B1=0, B2=1, C1=1", test_num);
            A1 = 0; A2 = 1; B1 = 0; B2 = 1; C1 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=1, B1=1, B2=0, C1=0", test_num);
            A1 = 0; A2 = 1; B1 = 1; B2 = 0; C1 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=1, B1=1, B2=0, C1=1", test_num);
            A1 = 0; A2 = 1; B1 = 1; B2 = 0; C1 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=1, B1=1, B2=1, C1=0", test_num);
            A1 = 0; A2 = 1; B1 = 1; B2 = 1; C1 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=1, B1=1, B2=1, C1=1", test_num);
            A1 = 0; A2 = 1; B1 = 1; B2 = 1; C1 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase017;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=0, B1=0, B2=0, C1=0", test_num);
            A1 = 1; A2 = 0; B1 = 0; B2 = 0; C1 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase018;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=0, B1=0, B2=0, C1=1", test_num);
            A1 = 1; A2 = 0; B1 = 0; B2 = 0; C1 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase019;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=0, B1=0, B2=1, C1=0", test_num);
            A1 = 1; A2 = 0; B1 = 0; B2 = 1; C1 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase020;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=0, B1=0, B2=1, C1=1", test_num);
            A1 = 1; A2 = 0; B1 = 0; B2 = 1; C1 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase021;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=0, B1=1, B2=0, C1=0", test_num);
            A1 = 1; A2 = 0; B1 = 1; B2 = 0; C1 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase022;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=0, B1=1, B2=0, C1=1", test_num);
            A1 = 1; A2 = 0; B1 = 1; B2 = 0; C1 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase023;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=0, B1=1, B2=1, C1=0", test_num);
            A1 = 1; A2 = 0; B1 = 1; B2 = 1; C1 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase024;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=0, B1=1, B2=1, C1=1", test_num);
            A1 = 1; A2 = 0; B1 = 1; B2 = 1; C1 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase025;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=1, B1=0, B2=0, C1=0", test_num);
            A1 = 1; A2 = 1; B1 = 0; B2 = 0; C1 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase026;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=1, B1=0, B2=0, C1=1", test_num);
            A1 = 1; A2 = 1; B1 = 0; B2 = 0; C1 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase027;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=1, B1=0, B2=1, C1=0", test_num);
            A1 = 1; A2 = 1; B1 = 0; B2 = 1; C1 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase028;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=1, B1=0, B2=1, C1=1", test_num);
            A1 = 1; A2 = 1; B1 = 0; B2 = 1; C1 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase029;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=1, B1=1, B2=0, C1=0", test_num);
            A1 = 1; A2 = 1; B1 = 1; B2 = 0; C1 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase030;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=1, B1=1, B2=0, C1=1", test_num);
            A1 = 1; A2 = 1; B1 = 1; B2 = 0; C1 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase031;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=1, B1=1, B2=1, C1=0", test_num);
            A1 = 1; A2 = 1; B1 = 1; B2 = 1; C1 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase032;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=1, B1=1, B2=1, C1=1", test_num);
            A1 = 1; A2 = 1; B1 = 1; B2 = 1; C1 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("combinational_logic Testbench");
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        testcase018();
        testcase019();
        testcase020();
        testcase021();
        testcase022();
        testcase023();
        testcase024();
        testcase025();
        testcase026();
        testcase027();
        testcase028();
        testcase029();
        testcase030();
        testcase031();
        testcase032();
        
        
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
