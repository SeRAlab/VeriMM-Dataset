`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    wire [23:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .a(a),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All zeros input", test_num);
            a = 16'h0000;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All ones in MSB 8-bits", test_num);
            a = 16'hFF00;
            #1;

            check_outputs(24'hFF0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Random pattern in MSB, zeros in LSB", test_num);
            a = 16'hA500;
            #1;

            check_outputs(24'hA50000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Values in LSB should be ignored", test_num);
            a = 16'h00FF;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Mixed bits in MSB and LSB", test_num);
            a = 16'h1234;
            #1;

            check_outputs(24'h120000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Boundary value 0x80", test_num);
            a = 16'h8000;
            #1;

            check_outputs(24'h800000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Boundary value 0x7F", test_num);
            a = 16'h7FFF;
            #1;

            check_outputs(24'h7F0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: High nibble calculation", test_num);
            a = 16'hF00D;
            #1;

            check_outputs(24'hF00000);
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
        input [23:0] expected_sum;
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
