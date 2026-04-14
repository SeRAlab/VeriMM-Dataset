`timescale 1ns/1ps

module adder_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire carry_out;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_32bit dut (
        .a(a),
        .b(b),
        .carry_out(carry_out),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'd100;
            b = 32'd200;
            $display("Test %0d: Simple addition (100 + 200)", test_num);
            #1;

            check_outputs(1'b0, 32'd300);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'h0;
            b = 32'h0;
            $display("Test %0d: Zero addition (0 + 0)", test_num);
            #1;

            check_outputs(1'b0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            $display("Test %0d: Pattern addition (0xAAAAAAAA + 0x55555555)", test_num);
            #1;

            check_outputs(1'b0, 32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0001;
            $display("Test %0d: Carry out boundary (Max + 1)", test_num);
            #1;

            check_outputs(1'b1, 32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'h8000_0000;
            b = 32'h8000_0000;
            $display("Test %0d: Large number carry (MSB + MSB)", test_num);
            #1;

            check_outputs(1'b1, 32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'hFFFF_FFFF;
            b = 32'hFFFF_FFFF;
            $display("Test %0d: Maximum sum (Max + Max)", test_num);
            #1;

            check_outputs(1'b1, 32'hFFFF_FFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'h1234_5678;
            b = 32'h8765_4321;
            $display("Test %0d: Complex addition", test_num);
            #1;

            check_outputs(1'b0, 32'h9999_9999);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'h0000_FFFF;
            b = 32'h0000_0001;
            $display("Test %0d: Lower bit carry propagation", test_num);
            #1;

            check_outputs(1'b0, 32'h0001_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_32bit Testbench");
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
        input expected_carry_out;
        input [31:0] expected_sum;
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
