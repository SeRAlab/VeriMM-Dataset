`timescale 1ns/1ps

module neighbor_relation_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] bits;
    wire [18:0] res_and;
    wire [18:0] res_or;
    wire [19:0] res_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neighbor_relation dut (
        .bits(bits),
        .res_and(res_and),
        .res_or(res_or),
        .res_xor(res_xor)
    );
    task testcase001;

    begin
        test_num = 1;
        bits = 20'h00000;
        $display("Running Testcase 001: All Zeros");
        #1;

        check_outputs(19'h00000, 19'h00000, 20'h00000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        bits = 20'hFFFFF;
        $display("Running Testcase 002: All Ones");



        #1;




        check_outputs(19'h7FFFF, 19'h7FFFF, 20'h00000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        bits = 20'hAAAAA;
        $display("Running Testcase 003: Alternating A");



        #1;




        check_outputs(19'h00000, 19'h7FFFF, 20'hFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        bits = 20'h55555;
        $display("Running Testcase 004: Alternating 5");
        #1;

        check_outputs(19'h00000, 19'h7FFFF, 20'hFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        bits = 20'h00001;
        $display("Running Testcase 005: Single LSB bit");



        #1;




        check_outputs(19'h00000, 19'h00001, 20'h80001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        bits = 20'h80000;
        $display("Running Testcase 006: Single MSB bit");



        #1;




        check_outputs(19'h00000, 19'h40000, 20'hC0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        bits = 20'h33333;
        $display("Running Testcase 007: Pattern 33333");

        #1;


        check_outputs(19'h11111, 19'h3BBBB, 20'hAAAAA);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        bits = 20'h12345;
        $display("Running Testcase 008: Pattern 12345");

        #1;


        check_outputs(19'h00100, 19'h1B3E7, 20'h9B2E7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neighbor_relation Testbench");
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
        input [18:0] expected_res_and;
        input [18:0] expected_res_or;
        input [19:0] expected_res_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res_and === (expected_res_and ^ res_and ^ expected_res_and) &&
                expected_res_or === (expected_res_or ^ res_or ^ expected_res_or) &&
                expected_res_xor === (expected_res_xor ^ res_xor ^ expected_res_xor)) begin
                $display("PASS");
                $display("  Outputs: res_and=%h, res_or=%h, res_xor=%h",
                         res_and, res_or, res_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res_and=%h, res_or=%h, res_xor=%h",
                         expected_res_and, expected_res_or, expected_res_xor);
                $display("  Got:      res_and=%h, res_or=%h, res_xor=%h",
                         res_and, res_or, res_xor);
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
