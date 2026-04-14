`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [16:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 + 0", test_num);
            a = 16'h0000;
            b = 16'h0000;
            #1;

            check_outputs(17'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FFFF + 0", test_num);
            a = 16'hFFFF;
            b = 16'h0000;
            #1;

            check_outputs(17'h0FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 + FFFF", test_num);
            a = 16'h0000;
            b = 16'hFFFF;
            #1;

            check_outputs(17'h0FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FFFF + FFFF (Max carry)", test_num);
            a = 16'hFFFF;
            b = 16'hFFFF;
            #1;

            check_outputs(17'h1FFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FFFF + 1 (Full propagation)", test_num);
            a = 16'hFFFF;
            b = 16'h0001;
            #1;

            check_outputs(17'h10000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: AAAA + 5555", test_num);
            a = 16'hAAAA;
            b = 16'h5555;
            #1;

            check_outputs(17'h0FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 00FF + 0001", test_num);
            a = 16'h00FF;
            b = 16'h0001;
            #1;

            check_outputs(17'h00100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8000 + 8000", test_num);
            a = 16'h8000;
            b = 16'h8000;
            #1;

            check_outputs(17'h10000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1234 + 5678", test_num);
            a = 16'h1234;
            b = 16'h5678;
            #1;

            check_outputs(17'h068AC);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: F0F0 + 0F0F", test_num);
            a = 16'hF0F0;
            b = 16'h0F0F;
            #1;

            check_outputs(17'h0FFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
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
        input [16:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
