`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Din;
    reg Lin;
    reg Rin;
    reg Uin;
    wire Dout;
    wire Lout;
    wire Rout;
    wire Uout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Din(Din),
        .Lin(Lin),
        .Rin(Rin),
        .Uin(Uin),
        .Dout(Dout),
        .Lout(Lout),
        .Rout(Rout),
        .Uout(Uout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All released", test_num);
            Uin = 0; Din = 0; Lin = 0; Rin = 0;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Up only", test_num);
            Uin = 1; Din = 0; Lin = 0; Rin = 0;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Down only", test_num);
            Uin = 0; Din = 1; Lin = 0; Rin = 0;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left only", test_num);
            Uin = 0; Din = 0; Lin = 1; Rin = 0;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right only", test_num);
            Uin = 0; Din = 0; Lin = 0; Rin = 1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Conflict Up/Down", test_num);
            Uin = 1; Din = 1; Lin = 0; Rin = 0;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Conflict Left/Right", test_num);
            Uin = 0; Din = 0; Lin = 1; Rin = 1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Diagonal Up/Left", test_num);
            Uin = 1; Din = 0; Lin = 1; Rin = 0;
            #1;

            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Diagonal Down/Right", test_num);
            Uin = 0; Din = 1; Lin = 0; Rin = 1;
            #1;

            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Up/Down/Left (Conflict + Valid)", test_num);
            Uin = 1; Din = 1; Lin = 1; Rin = 0;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All buttons pressed", test_num);
            Uin = 1; Din = 1; Lin = 1; Rin = 1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right and Up", test_num);
            Uin = 1; Din = 0; Lin = 0; Rin = 1;
            #1;

            check_outputs(0, 0, 1, 1);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input expected_Dout;
        input expected_Lout;
        input expected_Rout;
        input expected_Uout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout) &&
                expected_Lout === (expected_Lout ^ Lout ^ expected_Lout) &&
                expected_Rout === (expected_Rout ^ Rout ^ expected_Rout) &&
                expected_Uout === (expected_Uout ^ Uout ^ expected_Uout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%b, Lout=%b, Rout=%b, Uout=%b",
                         Dout, Lout, Rout, Uout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%b, Lout=%b, Rout=%b, Uout=%b",
                         expected_Dout, expected_Lout, expected_Rout, expected_Uout);
                $display("  Got:      Dout=%b, Lout=%b, Rout=%b, Uout=%b",
                         Dout, Lout, Rout, Uout);
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
