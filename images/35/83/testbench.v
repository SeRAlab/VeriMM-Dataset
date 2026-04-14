`timescale 1ns/1ps

module simple_hash_table_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] key;
    wire [2:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_hash_table dut (
        .key(key),
        .hash(hash)
    );
    task testcase001;

    begin
        test_num = 1;
        key = 5'd0;
        $display("Test %0d: Input key = %d (Expected 0)", test_num, key);
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        key = 5'd7;
        $display("Test %0d: Input key = %d (Expected 7)", test_num, key);
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        key = 5'd8;
        $display("Test %0d: Input key = %d (Expected 0)", test_num, key);
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        key = 5'd15;
        $display("Test %0d: Input key = %d (Expected 7)", test_num, key);
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        key = 5'd16;
        $display("Test %0d: Input key = %d (Expected 0)", test_num, key);
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        key = 5'd23;
        $display("Test %0d: Input key = %d (Expected 7)", test_num, key);
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        key = 5'd24;
        $display("Test %0d: Input key = %d (Expected 0)", test_num, key);
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        key = 5'd31;
        $display("Test %0d: Input key = %d (Expected 7)", test_num, key);
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        key = 5'd12;
        $display("Test %0d: Input key = %d (Expected 4)", test_num, key);
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        key = 5'd21;
        $display("Test %0d: Input key = %d (Expected 5)", test_num, key);
        #1;

        check_outputs(3'd5);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_hash_table Testbench");
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
        input [2:0] expected_hash;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: hash=%h",
                         hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h",
                         expected_hash);
                $display("  Got:      hash=%h",
                         hash);
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
