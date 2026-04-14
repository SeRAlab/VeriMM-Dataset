`timescale 1ns/1ps

module simple_hash_table_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] key;
    wire [2:0] hash_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_hash_table dut (
        .key(key),
        .hash_value(hash_value)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All zeros key", test_num);
            key = 5'b00000;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All ones key", test_num);
            key = 5'b11111;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Upper bits 1, Lower bits 0", test_num);
            key = 5'b11000;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Lower bits alternating 101", test_num);
            key = 5'b00101;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Lower bits alternating 010", test_num);
            key = 5'b11010;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Maximum value of lower 3 bits (7)", test_num);
            key = 5'b01111;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Middle value test (key=19, hash=3)", test_num);
            key = 5'd19;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Bit 2 only", test_num);
            key = 5'b00100;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Bit 1 only", test_num);
            key = 5'b00010;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Bit 0 only", test_num);
            key = 5'b00001;
            #1;

            check_outputs(3'b001);
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
        input [2:0] expected_hash_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hash_value === (expected_hash_value ^ hash_value ^ expected_hash_value)) begin
                $display("PASS");
                $display("  Outputs: hash_value=%h",
                         hash_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_value=%h",
                         expected_hash_value);
                $display("  Got:      hash_value=%h",
                         hash_value);
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
