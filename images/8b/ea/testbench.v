`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] addr1;
    reg [7:0] addr2;
    reg [15:0] data1;
    reg [15:0] data2;
    reg re1;
    reg re2;
    reg we1;
    reg we2;
    wire [15:0] q1;
    wire [15:0] q2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .data1(data1),
        .data2(data2),
        .re1(re1),
        .re2(re2),
        .we1(we1),
        .we2(we2),
        .q1(q1),
        .q2(q2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read Port 1", test_num);

            we1 = 0; we2 = 0; re1 = 0; re2 = 0;
            addr1 = 8'h00; addr2 = 8'h00;
            data1 = 16'h0000; data2 = 16'h0000;
            #10;


            addr1 = 8'hAA;
            data1 = 16'h1234;
            we1 = 1;
            #10;
            we1 = 0;


            re1 = 1;
            #1;

            check_outputs(16'h1234, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read Port 2", test_num);
            we1 = 0; we2 = 0; re1 = 0; re2 = 0;
            #10;


            addr2 = 8'hBB;
            data2 = 16'h5678;
            we2 = 1;
            #10;
            we2 = 0;


            re2 = 1;
            #1;

            check_outputs(16'h0000, 16'h5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous Writes to Different Addresses", test_num);
            we1 = 0; we2 = 0; re1 = 0; re2 = 0;
            #10;


            addr1 = 8'h01; data1 = 16'hAAAA; we1 = 1;
            addr2 = 8'h02; data2 = 16'h5555; we2 = 1;
            #10;
            we1 = 0; we2 = 0;


            re1 = 1; re2 = 1;
            #1;

            check_outputs(16'hAAAA, 16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Cross-Port Access", test_num);
            we1 = 0; we2 = 0; re1 = 0; re2 = 0;
            #10;


            addr1 = 8'hCC; data1 = 16'hDEAD; we1 = 1;
            #10;
            we1 = 0;


            addr2 = 8'hCC; re2 = 1;
            #1;

            check_outputs(16'h0000, 16'hDEAD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous Read and Write", test_num);
            we1 = 0; we2 = 0; re1 = 0; re2 = 0;
            #10;


            addr1 = 8'h10; data1 = 16'hBEEF; we1 = 1;
            #10;
            we1 = 0;


            addr1 = 8'h10; re1 = 1;
            addr2 = 8'h20; data2 = 16'hFACE; we2 = 1;
            #10;
            we2 = 0;


            re2 = 1;
            addr2 = 8'h20;
            #1;

            check_outputs(16'hBEEF, 16'hFACE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read Enable Verification", test_num);
            we1 = 0; we2 = 0; re1 = 0; re2 = 0;
            #10;


            addr1 = 8'h50; data1 = 16'h9999; we1 = 1;
            #10;
            we1 = 0;


            re1 = 0;
            addr1 = 8'h50;

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overwriting Data", test_num);
            we1 = 0; we2 = 0; re1 = 0; re2 = 0;
            #10;


            addr1 = 8'h77; data1 = 16'h1111; we1 = 1;
            #10;

            data1 = 16'h2222;
            #10;
            we1 = 0;

            re1 = 1;
            #1;

            check_outputs(16'h2222, 16'h0000);
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
        input [15:0] expected_q1;
        input [15:0] expected_q2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2)) begin
                $display("PASS");
                $display("  Outputs: q1=%h, q2=%h",
                         q1, q2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1=%h, q2=%h",
                         expected_q1, expected_q2);
                $display("  Got:      q1=%h, q2=%h",
                         q1, q2);
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
