`timescale 1ns/1ps

module XOR_8_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    XOR_8 dut (
        .A(A),
        .B(B),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'h00;
            B = 8'h00;
            $display("Testcase %0d: All Zeros (8'h00 ^ 8'h00)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'hFF;
            B = 8'h00;
            $display("Testcase %0d: Identity Property (8'hFF ^ 8'h00)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'hFF;
            B = 8'hFF;
            $display("Testcase %0d: Self Inverse (8'hFF ^ 8'hFF)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'h55;
            B = 8'hAA;
            $display("Testcase %0d: Checkerboard (8'h55 ^ 8'hAA)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'h12;
            B = 8'h34;
            $display("Testcase %0d: Hex 12 ^ Hex 34", test_num);
            #1;

            check_outputs(8'h26);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'h80;
            B = 8'h01;
            $display("Testcase %0d: Single Bits (8'h80 ^ 8'h01)", test_num);
            #1;

            check_outputs(8'h81);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'hF0;
            B = 8'h0F;
            $display("Testcase %0d: Nibbles (8'hF0 ^ 8'h0F)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'hA5;
            B = 8'h5A;
            $display("Testcase %0d: Arbitrary (8'hA5 ^ 8'h5A)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("XOR_8 Testbench");
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
        input [7:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
