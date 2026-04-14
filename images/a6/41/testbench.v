`timescale 1ns/1ps

module rshift_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [4:0] Shift;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rshift_32bit dut (
        .A(A),
        .Shift(Shift),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift by 0 (No change)", test_num);
            A = 32'h12345678;
            Shift = 5'd0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift all ones right by 1", test_num);
            A = 32'hFFFFFFFF;
            Shift = 5'd1;
            #1;

            check_outputs(32'h7FFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB shift to LSB (Shift by 31)", test_num);
            A = 32'h80000000;
            Shift = 5'd31;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift LSB out of bounds", test_num);
            A = 32'h00000001;
            Shift = 5'd1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern shift (AAAA_AAAA >> 4)", test_num);
            A = 32'hAAAAAAAA;
            Shift = 5'd4;
            #1;

            check_outputs(32'h0AAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Half word shift (5555_5555 >> 16)", test_num);
            A = 32'h55555555;
            Shift = 5'd16;
            #1;

            check_outputs(32'h00005555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero input shift", test_num);
            A = 32'h00000000;
            Shift = 5'd10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift by max amount (31) on all ones", test_num);
            A = 32'hFFFFFFFF;
            Shift = 5'd31;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Nibble alignment shift (F0F0_F0F0 >> 12)", test_num);
            A = 32'hF0F0F0F0;
            Shift = 5'd12;
            #1;

            check_outputs(32'h000F0F0F);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift resulting in zero (1234_5678 >> 31)", test_num);
            A = 32'h12345678;
            Shift = 5'd31;
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
        $display("rshift_32bit Testbench");
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
