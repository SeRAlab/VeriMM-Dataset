`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] In;
    wire [31:0] Out;

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
            test_num = test_num + 1;
            In = 32'h0000_0000;
            $display("Test %0d: All Zeros", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            In = 32'hFFFF_FFFF;
            $display("Test %0d: All Ones", test_num);
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            In = 32'h8000_0000;
            $display("Test %0d: Single Bit MSB", test_num);

            #1;


            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            In = 32'h0000_0001;
            $display("Test %0d: Single Bit LSB", test_num);

            #1;


            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            In = 32'hAAAA_AAAA;
            $display("Test %0d: Alternating Bits (1010...)", test_num);

            #1;


            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            In = 32'h1234_5678;
            $display("Test %0d: Hex Pattern 12345678", test_num);




            #1;





            check_outputs(32'h1E6A2C48);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            In = 32'hF0F0_F0F0;
            $display("Test %0d: Nibble pattern F0", test_num);

            #1;


            check_outputs(32'h0F0F_0F0F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            In = 32'hCC33_AA55;
            $display("Test %0d: Pattern CC33AA55", test_num);


            #1;



            check_outputs(32'hAA55_CC33);
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
        input [31:0] expected_Out;
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
