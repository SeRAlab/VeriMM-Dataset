`timescale 1ns/1ps

module ripple_carry_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire carry_out;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ripple_carry_adder dut (
        .a(a),
        .b(b),
        .carry_out(carry_out),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'h00; b = 8'h00;
            $display("Test Case %03d: Addition of zero (0x00 + 0x00)", test_num);
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'hFF; b = 8'h00;
            $display("Test Case %03d: Max value plus zero (0xFF + 0x00)", test_num);
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'h00; b = 8'hFF;
            $display("Test Case %03d: Zero plus max value (0x00 + 0xFF)", test_num);
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'hFF; b = 8'h01;
            $display("Test Case %03d: Carry out generation (0xFF + 0x01)", test_num);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'h7F; b = 8'h01;
            $display("Test Case %03d: Bit 7 carry (0x7F + 0x01)", test_num);
            #1;

            check_outputs(1'b0, 8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'h55; b = 8'hAA;
            $display("Test Case %03d: Alternating bits (0x55 + 0xAA)", test_num);
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 8'hFF; b = 8'hFF;
            $display("Test Case %03d: Maximum addition (0xFF + 0xFF)", test_num);
            #1;

            check_outputs(1'b1, 8'hFE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 8'h80; b = 8'h80;
            $display("Test Case %03d: Carry from MSB only (0x80 + 0x80)", test_num);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 8'h12; b = 8'h34;
            $display("Test Case %03d: Random small numbers (0x12 + 0x34)", test_num);
            #1;

            check_outputs(1'b0, 8'h46);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 8'hA5; b = 8'h5A;
            $display("Test Case %03d: Inverted patterns (0xA5 + 0x5A)", test_num);
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ripple_carry_adder Testbench");
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
        input [7:0] expected_sum;
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
