`timescale 1ns/1ps

module four_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire C_OUT;
    wire [4:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_bit_adder dut (
        .A(A),
        .B(B),
        .C_OUT(C_OUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        A = 4'b0000; B = 4'b0000;
        test_num = test_num + 1;
        $display("Test %0d: Zero addition (0 + 0)", test_num);
        #1;

        check_outputs(1'b0, 5'd0);
    end
        endtask

    task testcase002;

    begin
        A = 4'b0011; B = 4'b0100;
        test_num = test_num + 1;
        $display("Test %0d: Simple addition (3 + 4)", test_num);
        #1;

        check_outputs(1'b0, 5'd7);
    end
        endtask

    task testcase003;

    begin
        A = 4'b1111; B = 4'b0000;
        test_num = test_num + 1;
        $display("Test %0d: Boundary case (15 + 0)", test_num);
        #1;

        check_outputs(1'b0, 5'd15);
    end
        endtask

    task testcase004;

    begin
        A = 4'b1111; B = 4'b0001;
        test_num = test_num + 1;
        $display("Test %0d: Carry out generation (15 + 1)", test_num);
        #1;

        check_outputs(1'b1, 5'd16);
    end
        endtask

    task testcase005;

    begin
        A = 4'b1000; B = 4'b1000;
        test_num = test_num + 1;
        $display("Test %0d: Power of two carry (8 + 8)", test_num);
        #1;

        check_outputs(1'b1, 5'd16);
    end
        endtask

    task testcase006;

    begin
        A = 4'b1010; B = 4'b0101;
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits (10 + 5)", test_num);
        #1;

        check_outputs(1'b0, 5'd15);
    end
        endtask

    task testcase007;

    begin
        A = 4'b1111; B = 4'b1111;
        test_num = test_num + 1;
        $display("Test %0d: Maximum values (15 + 15)", test_num);
        #1;

        check_outputs(1'b1, 5'd30);
    end
        endtask

    task testcase008;

    begin
        A = 4'b1100; B = 4'b0100;
        test_num = test_num + 1;
        $display("Test %0d: Carry at MSB (12 + 4)", test_num);
        #1;

        check_outputs(1'b1, 5'd16);
    end
        endtask

    task testcase009;

    begin
        A = 4'b0111; B = 4'b0001;
        test_num = test_num + 1;
        $display("Test %0d: No carry out (7 + 1)", test_num);
        #1;

        check_outputs(1'b0, 5'd8);
    end
        endtask

    task testcase010;

    begin
        A = 4'b1001; B = 4'b0111;
        test_num = test_num + 1;
        $display("Test %0d: Complex addition (9 + 7)", test_num);
        #1;

        check_outputs(1'b1, 5'd16);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_bit_adder Testbench");
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
        input expected_C_OUT;
        input [4:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_OUT === (expected_C_OUT ^ C_OUT ^ expected_C_OUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: C_OUT=%b, SUM=%h",
                         C_OUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_OUT=%b, SUM=%h",
                         expected_C_OUT, expected_SUM);
                $display("  Got:      C_OUT=%b, SUM=%h",
                         C_OUT, SUM);
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
