`timescale 1ns/1ps

module alu_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] F;
    wire [31:0] Y;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu dut (
        .A(A),
        .B(B),
        .F(F),
        .Y(Y),
        .Zero(Zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (F=000)", test_num);
            A = 32'hAAAA_AAAA;
            B = 32'h5555_5555;
            F = 3'b000;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (F=000)", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'h1234_5678;
            F = 3'b000;

            #1;


            check_outputs(32'h1234_5678, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR (F=001)", test_num);
            A = 32'hAAAA_0000;
            B = 32'h0000_5555;
            F = 3'b001;

            #1;


            check_outputs(32'hAAAA_5555, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (F=010)", test_num);
            A = 32'd100;
            B = 32'd250;
            F = 3'b010;

            #1;


            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow/Zero (F=010)", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            F = 3'b010;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: AND with negated B (F=011)", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'h0000_FFFF;
            F = 3'b011;

            #1;


            check_outputs(32'hFFFF_0000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with negated B (F=101)", test_num);
            A = 32'd10;
            B = 32'd5;
            F = 3'b101;

            #1;


            check_outputs(32'd4, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (F=110)", test_num);
            A = 32'd500;
            B = 32'd200;
            F = 3'b110;

            #1;


            check_outputs(32'd300, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Zero (F=110)", test_num);
            A = 32'h1234_5678;
            B = 32'h1234_5678;
            F = 3'b110;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLT True (F=111)", test_num);
            A = 32'd10;
            B = 32'd20;
            F = 3'b111;

            #1;


            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLT False (F=111)", test_num);
            A = 32'd20;
            B = 32'd10;
            F = 3'b111;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLT Equal (F=111)", test_num);
            A = 32'd15;
            B = 32'd15;
            F = 3'b111;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input [31:0] expected_Y;
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Y=%h, Zero=%b",
                         Y, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h, Zero=%b",
                         expected_Y, expected_Zero);
                $display("  Got:      Y=%h, Zero=%b",
                         Y, Zero);
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
