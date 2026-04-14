`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg sign;
    wire [63:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sign(sign),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned 10 * 20", test_num);
            sign = 0;
            A = 32'd10;
            B = 32'd20;
            #1;

            check_outputs(64'd200);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned 0 * 12345", test_num);
            sign = 0;
            A = 32'd0;
            B = 32'd12345;
            #1;

            check_outputs(64'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned Max * Max", test_num);
            sign = 0;
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;

            #1;


            check_outputs(64'hFFFFFFFF00000001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed 15 * 4", test_num);
            sign = 1;
            A = 32'sd15;
            B = 32'sd4;
            #1;

            check_outputs(64'sd60);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed 10 * -5", test_num);
            sign = 1;
            A = 32'sd10;
            B = -32'sd5;
            #1;

            check_outputs(-64'sd50);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed -100 * 2", test_num);
            sign = 1;
            A = -32'sd100;
            B = 32'sd2;
            #1;

            check_outputs(-64'sd200);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed -12 * -12", test_num);
            sign = 1;
            A = -32'sd12;
            B = -32'sd12;
            #1;

            check_outputs(64'sd144);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed 0x1234 * -1", test_num);
            sign = 1;
            A = 32'h1234;
            B = 32'hFFFFFFFF;
            #1;

            check_outputs(-64'sd4660);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed MaxPos * MinNeg", test_num);
            sign = 1;
            A = 32'h7FFFFFFF;
            B = 32'h80000000;

            #1;


            check_outputs(64'hC000000080000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed MinNeg * MinNeg", test_num);
            sign = 1;
            A = 32'h80000000;
            B = 32'h80000000;

            #1;


            check_outputs(64'h4000000000000000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned vs Signed with 0xFFFFFFFF * 1", test_num);


            sign = 0;
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            #1;

            check_outputs(64'h00000000FFFFFFFF);


            test_num = test_num + 1;
            sign = 1;
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [63:0] expected_Z;
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
