`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .A(A),
        .B(B),
        .C(C),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All signals silent (zero)", test_num);
            A = 8'd0;
            B = 8'd0;
            C = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All signals at maximum", test_num);
            A = 8'd255;
            B = 8'd255;
            C = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical mid-range values", test_num);
            A = 8'd120;
            B = 8'd120;
            C = 8'd120;
            #1;

            check_outputs(8'd120);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple average (divisible by 3)", test_num);
            A = 8'd10;
            B = 8'd20;
            C = 8'd30;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Truncation check (remainder 1)", test_num);
            A = 8'd10;
            B = 8'd10;
            C = 8'd11;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Truncation check (remainder 2)", test_num);
            A = 8'd100;
            B = 8'd100;
            C = 8'd101;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single active signal", test_num);
            A = 8'd90;
            B = 8'd0;
            C = 8'd0;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two active signals", test_num);
            A = 8'd255;
            B = 8'd255;
            C = 8'd0;
            #1;

            check_outputs(8'd170);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed high values", test_num);
            A = 8'd200;
            B = 8'd150;
            C = 8'd100;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum possible sum sum check", test_num);
            A = 8'd255;
            B = 8'd255;
            C = 8'd254;
            #1;

            check_outputs(8'd254);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_mixer Testbench");
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
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
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
