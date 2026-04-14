`timescale 1ns/1ps

module eight_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire CARRY;
    wire [7:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eight_bit_adder dut (
        .A(A),
        .B(B),
        .CARRY(CARRY),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 8'd0; B = 8'd0;
        $display("Test %0d: Zero addition (0 + 0)", test_num);
        #1;

        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 8'd15; B = 8'd30;
        $display("Test %0d: Simple addition (15 + 30)", test_num);
        #1;

        check_outputs(1'b0, 8'd45);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 8'd255; B = 8'd0;
        $display("Test %0d: Max value plus zero (255 + 0)", test_num);
        #1;

        check_outputs(1'b0, 8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 8'd128; B = 8'd127;
        $display("Test %0d: Boundary check no carry (128 + 127)", test_num);
        #1;

        check_outputs(1'b0, 8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 8'd128; B = 8'd128;
        $display("Test %0d: Boundary check with carry (128 + 128)", test_num);
        #1;

        check_outputs(1'b1, 8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 8'd255; B = 8'd1;
        $display("Test %0d: Carry out check (255 + 1)", test_num);
        #1;

        check_outputs(1'b1, 8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 8'hAA; B = 8'h55;
        $display("Test %0d: Alternating bits (0xAA + 0x55)", test_num);
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 8'd255; B = 8'd255;
        $display("Test %0d: Maximum possible sum (255 + 255)", test_num);
        #1;

        check_outputs(1'b1, 8'd254);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 8'd200; B = 8'd100;
        $display("Test %0d: Mid-range carry (200 + 100)", test_num);
        #1;

        check_outputs(1'b1, 8'd44);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 8'hF0; B = 8'h10;
        $display("Test %0d: High nibble carry (0xF0 + 0x10)", test_num);
        #1;

        check_outputs(1'b1, 8'h00);
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
        input expected_CARRY;
        input [7:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CARRY === (expected_CARRY ^ CARRY ^ expected_CARRY) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: CARRY=%b, SUM=%h",
                         CARRY, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CARRY=%b, SUM=%h",
                         expected_CARRY, expected_SUM);
                $display("  Got:      CARRY=%b, SUM=%h",
                         CARRY, SUM);
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
