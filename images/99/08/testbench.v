`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] In;
    wire [7:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In(In),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = 1;
            In = 6'b000000;
            $display("Test %0d: In = %b", test_num, In);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            In = 6'b011111;
            $display("Test %0d: In = %b", test_num, In);
            #1;

            check_outputs(8'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            In = 6'b100000;
            $display("Test %0d: In = %b", test_num, In);
            #1;

            check_outputs(8'hE0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            In = 6'b111111;
            $display("Test %0d: In = %b", test_num, In);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            In = 6'b010101;
            $display("Test %0d: In = %b", test_num, In);
            #1;

            check_outputs(8'h15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            In = 6'b101010;
            $display("Test %0d: In = %b", test_num, In);
            #1;

            check_outputs(8'hEA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            In = 6'b001100;
            $display("Test %0d: In = %b", test_num, In);
            #1;

            check_outputs(8'h0C);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            In = 6'b110011;
            $display("Test %0d: In = %b", test_num, In);
            #1;

            check_outputs(8'hF3);
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
        input [7:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
