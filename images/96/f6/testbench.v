`timescale 1ns/1ps

module bitwise_or_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] g;
    reg [4:0] h;
    wire [4:0] i;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_or dut (
        .g(g),
        .h(h),
        .i(i)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            g = 5'b00000;
            h = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            g = 5'b11111;
            h = 5'b11111;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (No Overlap)", test_num);
            g = 5'b10101;
            h = 5'b01010;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bits with Overlap", test_num);
            g = 5'b01100;
            h = 5'b00110;
            #1;

            check_outputs(5'b01110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: One input Zero", test_num);
            g = 5'b10001;
            h = 5'b00000;
            #1;

            check_outputs(5'b10001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit OR", test_num);
            g = 5'b00010;
            h = 5'b00100;
            #1;

            check_outputs(5'b00110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB and LSB OR", test_num);
            g = 5'b10000;
            h = 5'b00001;
            #1;

            check_outputs(5'b10001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_or Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [4:0] expected_i;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i === (expected_i ^ i ^ expected_i)) begin
                $display("PASS");
                $display("  Outputs: i=%h",
                         i);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i=%h",
                         expected_i);
                $display("  Got:      i=%h",
                         i);
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
