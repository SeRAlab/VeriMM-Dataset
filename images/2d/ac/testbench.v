`timescale 1ns/1ps

module brent_kung_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire COUT;
    wire [3:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    brent_kung_adder dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'd0; B = 4'd0;
            $display("Test %0d: Zero addition", test_num);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'd5; B = 4'd3;
            $display("Test %0d: Small sum no carry", test_num);
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'd15; B = 4'd0;
            $display("Test %0d: Max A with zero", test_num);
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'd15; B = 4'd1;
            $display("Test %0d: Carry out to bit 4", test_num);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'd7; B = 4'd8;
            $display("Test %0d: Sum to 15 (no carry)", test_num);
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'd8; B = 4'd8;
            $display("Test %0d: Carry out from MSB", test_num);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'd10; B = 4'd5;
            $display("Test %0d: Alternating bits (1010 + 0101)", test_num);
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'd15; B = 4'd15;
            $display("Test %0d: Max values addition", test_num);
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 4'b0111; B = 4'b0001;
            $display("Test %0d: Carry ripple across lower bits", test_num);
            #1;

            check_outputs(1'b0, 4'b1000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 4'd12; B = 4'd4;
            $display("Test %0d: Boundary carry", test_num);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("brent_kung_adder Testbench");
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
        input expected_COUT;
        input [3:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%h",
                         COUT, SUM);
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
