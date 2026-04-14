`timescale 1ns/1ps

module eight_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [8:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eight_bit_adder dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Addition (0 + 0)", test_num);
        a = 8'h00;
        b = 8'h00;
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Values (255 + 255)", test_num);
        a = 8'hFF;
        b = 8'hFF;
        #1;

        check_outputs(9'h1FE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Carry-out Boundary (255 + 1)", test_num);
        a = 8'hFF;
        b = 8'h01;
        #1;

        check_outputs(9'h100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bit Patterns (0xAA + 0x55)", test_num);
        a = 8'hAA;
        b = 8'h55;
        #1;

        check_outputs(9'h0FF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-range Addition (128 + 128)", test_num);
        a = 8'h80;
        b = 8'h80;
        #1;

        check_outputs(9'h100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Property (123 + 0)", test_num);
        a = 8'd123;
        b = 8'd0;
        #1;

        check_outputs(9'd123);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Small Values (5 + 12)", test_num);
        a = 8'd5;
        b = 8'd12;
        #1;

        check_outputs(9'd17);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Internal Nibble Carry (0x0F + 0x01)", test_num);
        a = 8'h0F;
        b = 8'h01;
        #1;

        check_outputs(9'h010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eight_bit_adder Testbench");
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
        input [8:0] expected_sum;
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
