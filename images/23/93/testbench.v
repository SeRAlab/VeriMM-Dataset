`timescale 1ns/1ps

module adder_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire carry_out;
    wire [63:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_64bit dut (
        .a(a),
        .b(b),
        .carry_out(carry_out),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero addition (0 + 0)", test_num);
            a = 64'h0;
            b = 64'h0;
            #1;

            check_outputs(1'b0, 64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity addition (A + 0)", test_num);
            a = 64'hFEDCBA9876543210;
            b = 64'h0;
            #1;

            check_outputs(1'b0, 64'hFEDCBA9876543210);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small value addition without carry-out", test_num);
            a = 64'h0000000000000005;
            b = 64'h000000000000000A;
            #1;

            check_outputs(1'b0, 64'h000000000000000F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large value addition without carry-out", test_num);
            a = 64'h7FFFFFFFFFFFFFFF;
            b = 64'h0000000000000001;
            #1;

            check_outputs(1'b0, 64'h8000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum value plus one (Should trigger carry-out)", test_num);
            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'h0000000000000001;
            #1;

            check_outputs(1'b1, 64'h0000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits addition (0x55... + 0xAA...)", test_num);
            a = 64'h5555555555555555;
            b = 64'hAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum values addition (Max + Max)", test_num);
            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'hFFFFFFFFFFFFFFFF;

            #1;


            check_outputs(1'b1, 64'hFFFFFFFFFFFFFFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry propagation from low to high bits", test_num);
            a = 64'h00000000FFFFFFFF;
            b = 64'h0000000100000001;
            #1;

            check_outputs(1'b0, 64'h0000000200000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSB addition triggering carry-out", test_num);
            a = 64'h8000000000000000;
            b = 64'h8000000000000000;
            #1;

            check_outputs(1'b1, 64'h0000000000000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random pattern addition", test_num);
            a = 64'h123456789ABCDEF0;
            b = 64'hEDCBA9876543210F;

            #1;


            check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_64bit Testbench");
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
        input expected_carry_out;
        input [63:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, sum=%h",
                         carry_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, sum=%h",
                         expected_carry_out, expected_sum);
                $display("  Got:      carry_out=%b, sum=%h",
                         carry_out, sum);
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
