`timescale 1ns/1ps

module v306ca3_v9a2a06_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] i;
    wire [7:0] o0;
    wire [7:0] o1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    v306ca3_v9a2a06 dut (
        .i(i),
        .o0(o0),
        .o1(o1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All Zeros", test_num);
            i = 16'h0000;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All Ones", test_num);
            i = 16'hFFFF;
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Alternating Bits pattern 1", test_num);
            i = 16'hA55A;
            #1;

            check_outputs(8'h5A, 8'hA5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Sequential Nibbles", test_num);
            i = 16'h1234;
            #1;

            check_outputs(8'h34, 8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: MSB High, LSB Low", test_num);
            i = 16'hFF00;
            #1;

            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: MSB Low, LSB High", test_num);
            i = 16'h00FF;
            #1;

            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Specific Hex Value BEEF", test_num);
            i = 16'hBEEF;
            #1;

            check_outputs(8'hEF, 8'hBE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Single Bit Transitions", test_num);
            i = 16'h8001;
            #1;

            check_outputs(8'h01, 8'h80);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Midpoint Value", test_num);
            i = 16'h7F80;
            #1;

            check_outputs(8'h80, 8'h7F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Alternating Bits pattern 2", test_num);
            i = 16'h5AA5;
            #1;

            check_outputs(8'hA5, 8'h5A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("v306ca3_v9a2a06 Testbench");
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
        input [7:0] expected_o0;
        input [7:0] expected_o1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1)) begin
                $display("PASS");
                $display("  Outputs: o0=%h, o1=%h",
                         o0, o1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%h, o1=%h",
                         expected_o0, expected_o1);
                $display("  Got:      o0=%h, o1=%h",
                         o0, o1);
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
