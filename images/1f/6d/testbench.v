`timescale 1ns/1ps

module rsa_transform_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] a;
    reg [9:0] b;
    wire [9:0] encrypted_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_transform dut (
        .a(a),
        .b(b),
        .encrypted_output(encrypted_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero inputs", test_num);
        a = 10'd0;
        b = 10'd0;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sum less than 17", test_num);
        a = 10'd5;
        b = 10'd5;
        #1;

        check_outputs(10'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sum equal to 17", test_num);
        a = 10'd10;
        b = 10'd7;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sum greater than 17", test_num);
        a = 10'd15;
        b = 10'd5;
        #1;

        check_outputs(10'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large input A (Max 10-bit), B=0", test_num);
        a = 10'd1023;
        b = 10'd0;
        #1;

        check_outputs(10'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum possible sum (1023+1023)", test_num);
        a = 10'd1023;
        b = 10'd1023;
        #1;

        check_outputs(10'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sum of 512+512", test_num);
        a = 10'd512;
        b = 10'd512;
        #1;

        check_outputs(10'd4);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Remainder is 16", test_num);
        a = 10'd1;
        b = 10'd15;
        #1;

        check_outputs(10'd16);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rsa_transform Testbench");
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
        input [9:0] expected_encrypted_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encrypted_output === (expected_encrypted_output ^ encrypted_output ^ expected_encrypted_output)) begin
                $display("PASS");
                $display("  Outputs: encrypted_output=%h",
                         encrypted_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encrypted_output=%h",
                         expected_encrypted_output);
                $display("  Got:      encrypted_output=%h",
                         encrypted_output);
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
