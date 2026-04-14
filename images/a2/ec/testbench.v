`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Din;
    wire [23:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Din(Din),
        .Dout(Dout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Zeros", test_num);
        Din = 32'h0000_0000;
        #1;

        check_outputs(24'h000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All Ones", test_num);
        Din = 32'hFFFF_FFFF;
        #1;

        check_outputs(24'hFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Alternating Bits 1 (0101...)", test_num);
        Din = 32'h5555_5555;


        #1;



        check_outputs(24'hAAAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Alternating Bits 2 (1010...)", test_num);
        Din = 32'hAAAA_AAAA;


        #1;



        check_outputs(24'h555555);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Pattern 0x12345678", test_num);
        Din = 32'h1234_5678;

        #1;


        check_outputs(24'h2468AC);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Pattern 0xABCDEF01", test_num);
        Din = 32'hABCDEF01;

        #1;


        check_outputs(24'h579BDE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Boundary Check - Bit 31 and Bit 6 set", test_num);
        Din = 32'h8000_0040;

        #1;


        check_outputs(24'h000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Boundary Check - Bit 30 set (MSB of slice)", test_num);
        Din = 32'h4000_0000;

        #1;


        check_outputs(24'h800000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Boundary Check - Bit 7 set (LSB of slice)", test_num);
        Din = 32'h0000_0080;

        #1;


        check_outputs(24'h000001);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Boundary Check - Bits 30 and 7 set", test_num);
        Din = 32'h4000_0080;
        #1;

        check_outputs(24'h800001);
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
        input [23:0] expected_Dout;
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
