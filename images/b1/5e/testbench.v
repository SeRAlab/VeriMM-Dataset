`timescale 1ns/1ps

module adder16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder16bit dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 16'h0000;
            b = 16'h0000;
            $display("Test %0d: All zeros", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 16'h1234;
            b = 16'h0000;
            $display("Test %0d: Identity addition (a + 0)", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 16'h0000;
            b = 16'hABCD;
            $display("Test %0d: Identity addition (0 + b)", test_num);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 16'h0005;
            b = 16'h000A;
            $display("Test %0d: Simple addition", test_num);
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 16'h5555;
            b = 16'hAAAA;
            $display("Test %0d: Alternating bit patterns", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 16'hFFFF;
            b = 16'h0001;
            $display("Test %0d: Overflow case (result wraps to 0)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 16'h8000;
            b = 16'h8000;
            $display("Test %0d: MSB addition (result wraps to 0)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 16'hFFFF;
            b = 16'hFFFF;
            $display("Test %0d: Maximum values (result wraps to FFFE)", test_num);
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 16'h1234;
            b = 16'h4321;
            $display("Test %0d: Arbitrary addition", test_num);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 16'h7FFF;
            b = 16'h0001;
            $display("Test %0d: Lower bits carry to MSB", test_num);
            #1;

            check_outputs(16'h8000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder16bit Testbench");
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
