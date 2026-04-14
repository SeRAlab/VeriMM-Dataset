`timescale 1ns/1ps

module and_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and_32bit dut (
        .A(A),
        .B(B),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 32'h00000000;
            B = 32'h00000000;
            $display("Test %03d: All Zeros (0x0 & 0x0)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            $display("Test %03d: All Ones (0xFFFFFFFF & 0xFFFFFFFF)", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 32'hFFFFFFFF;
            B = 32'h00000000;
            $display("Test %03d: Identity Zero (0xFFFFFFFF & 0x0)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 32'hAAAAAAAA;
            B = 32'h55555555;
            $display("Test %03d: Alternating Bits (0xAAAAAAAA & 0x55555555)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 32'hF0F0F0F0;
            B = 32'hFFFF0000;
            $display("Test %03d: Partial Overlap (0xF0F0F0F0 & 0xFFFF0000)", test_num);
            #1;

            check_outputs(32'hF0F00000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 32'h12345678;
            B = 32'hFFFFFFFF;
            $display("Test %03d: Identity with All Ones (0x12345678 & 0xFFFFFFFF)", test_num);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 32'hDEADBEEF;
            B = 32'hCAFEBABE;
            $display("Test %03d: Arbitrary Hex (0xDEADBEEF & 0xCAFEBABE)", test_num);
            #1;

            check_outputs(32'hCAAA2AEE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 32'h80000001;
            B = 32'h80000001;
            $display("Test %03d: Boundary Bits (MSB/LSB Only)", test_num);
            #1;

            check_outputs(32'h80000001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 32'hCCCCCCCC;
            B = 32'h33333333;
            $display("Test %03d: Bitwise Inverse (0xCCCCCCCC & 0x33333333)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 32'hFFFF0000;
            B = 32'h0000FFFF;
            $display("Test %03d: Upper/Lower Split", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and_32bit Testbench");
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
