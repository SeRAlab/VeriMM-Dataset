`timescale 1ns/1ps

module adder_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x;
    reg [15:0] y;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_16bit dut (
        .x(x),
        .y(y),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 16'h0000;
            y = 16'h0000;
            $display("Test %0d: Zero addition (0 + 0)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 16'h1234;
            y = 16'h4321;
            $display("Test %0d: Simple addition (0x1234 + 0x4321)", test_num);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 16'hFFFF;
            y = 16'h0001;
            $display("Test %0d: Overflow rollover (0xFFFF + 0x0001)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 16'hAAAA;
            y = 16'h5555;
            $display("Test %0d: Full bit range (0xAAAA + 0x5555)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 16'h8000;
            y = 16'h8000;
            $display("Test %0d: Large value overflow (0x8000 + 0x8000)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 16'h00FF;
            y = 16'hFF00;
            $display("Test %0d: Byte swap addition (0x00FF + 0xFF00)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 16'hFFFF;
            y = 16'hFFFF;
            $display("Test %0d: Max values (0xFFFF + 0xFFFF)", test_num);
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x = 16'h1357;
            y = 16'h2468;
            $display("Test %0d: Arbitrary addition (0x1357 + 0x2468)", test_num);
            #1;

            check_outputs(16'h37BF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_16bit Testbench");
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
        input [15:0] expected_sum;
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
