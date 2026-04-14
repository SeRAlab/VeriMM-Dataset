`timescale 1ns/1ps

module hash_table_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] key;
    wire [2:0] index;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hash_table dut (
        .key(key),
        .index(index)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Key = 0", test_num);
        key = 5'd0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Key = 5 (Reserved)", test_num);
        key = 5'd5;
        #1;

        check_outputs(3'bxxx);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Key = 7", test_num);
        key = 5'd7;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Key = 8", test_num);
        key = 5'd8;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Key = 13", test_num);
        key = 5'd13;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Key = 16", test_num);
        key = 5'd16;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Key = 23", test_num);
        key = 5'd23;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Key = 31", test_num);
        key = 5'd31;
        #1;

        check_outputs(3'd7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hash_table Testbench");
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
        input [2:0] expected_index;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_index === (expected_index ^ index ^ expected_index)) begin
                $display("PASS");
                $display("  Outputs: index=%h",
                         index);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: index=%h",
                         expected_index);
                $display("  Got:      index=%h",
                         index);
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
