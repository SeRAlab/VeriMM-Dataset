`timescale 1ns/1ps

module slice_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] Din;
    wire [4:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slice_module dut (
        .Din(Din),
        .Dout(Dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            Din = 16'h0000;
            $display("Test Case %0d: Input all zeros", test_num);
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            Din = 16'hFFFF;
            $display("Test Case %0d: Input all ones", test_num);
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;

            Din = 16'b0001_1111_0000_0000;
            $display("Test Case %0d: Bits 12-8 high, others low", test_num);
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;

            Din = 16'b1110_0000_1111_1111;
            $display("Test Case %0d: Bits 12-8 low, others high", test_num);
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;

            Din = 16'b0111_0101_1010_1010;
            $display("Test Case %0d: Pattern 10101 in slice", test_num);
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;

            Din = 16'b1000_1010_0101_0101;
            $display("Test Case %0d: Pattern 01010 in slice", test_num);
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;


            Din = 16'hABCD;
            $display("Test Case %0d: Input 0xABCD", test_num);
            #1;

            check_outputs(5'h0B);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;


            Din = 16'h1234;
            $display("Test Case %0d: Input 0x1234", test_num);
            #1;

            check_outputs(5'h12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slice_module Testbench");
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
        input [4:0] expected_Dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h",
                         expected_Dout);
                $display("  Got:      Dout=%h",
                         Dout);
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
