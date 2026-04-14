`timescale 1ns/1ps

module ALU_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] OpSel;
    wire [31:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_32bit dut (
        .A(A),
        .B(B),
        .OpSel(OpSel),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition - Simple (10 + 20)", test_num);
            A = 32'd10;
            B = 32'd20;
            OpSel = 2'b00;
            #1;

            check_outputs(32'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition - Max Value Wraparound", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            OpSel = 2'b00;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction - Simple (100 - 40)", test_num);
            A = 32'd100;
            B = 32'd40;
            OpSel = 2'b01;
            #1;

            check_outputs(32'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction - Underflow (5 - 10)", test_num);
            A = 32'd5;
            B = 32'd10;
            OpSel = 2'b01;
            #1;

            check_outputs(32'hFFFFFB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND - Masking", test_num);
            A = 32'h12345678;
            B = 32'hFFFF0000;
            OpSel = 2'b10;
            #1;

            check_outputs(32'h12340000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND - Zero result", test_num);
            A = 32'hAAAAAAAA;
            B = 32'h55555555;
            OpSel = 2'b10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR - Combining", test_num);
            A = 32'h12340000;
            B = 32'h00005678;
            OpSel = 2'b11;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR - All ones", test_num);
            A = 32'hAAAAAAAA;
            B = 32'h55555555;
            OpSel = 2'b11;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction - Result Zero", test_num);
            A = 32'hDEADBEEF;
            B = 32'hDEADBEEF;
            OpSel = 2'b01;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition - Two Large Numbers", test_num);
            A = 32'h7FFFFFFF;
            B = 32'h7FFFFFFF;
            OpSel = 2'b00;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_32bit Testbench");
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
        input [31:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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
