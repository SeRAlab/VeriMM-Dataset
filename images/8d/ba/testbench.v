`timescale 1ns/1ps

module nor_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nor_32bit dut (
        .a(a),
        .b(b),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All zeros input", test_num);
        a = 32'h00000000;
        b = 32'h00000000;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All ones input", test_num);
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: One input all ones, other all zeros", test_num);
        a = 32'hFFFFFFFF;
        b = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Alternating bit patterns (Complementary)", test_num);
        a = 32'hAAAAAAAA;
        b = 32'h55555555;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Alternating bit patterns (Same)", test_num);
        a = 32'hAAAAAAAA;
        b = 32'hAAAAAAAA;

        #1;


        check_outputs(32'h55555555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Test lower 16-bit block", test_num);
        a = 32'h0000FFFF;
        b = 32'h00000000;

        #1;


        check_outputs(32'hFFFF0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Test upper 16-bit block", test_num);
        a = 32'hFFFF0000;
        b = 32'h00000000;

        #1;


        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Test boundary bits (15 and 16)", test_num);
        a = 32'h00008000;
        b = 32'h00010000;

        #1;


        check_outputs(32'hFFFE7FFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Random pattern verification", test_num);
        a = 32'h12345678;
        b = 32'h87654321;


        #1;



        check_outputs(32'h688AA886);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Single bit walk", test_num);
        a = 32'h80000001;
        b = 32'h00000000;

        #1;


        check_outputs(32'h7FFFFFFE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nor_32bit Testbench");
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
