`timescale 1ns/1ps

module hash_table_tb;

    // Testbench signals (combinational circuit)
    reg insert;
    reg [4:0] key;
    reg lookup;
    wire found;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hash_table dut (
        .insert(insert),
        .key(key),
        .lookup(lookup),
        .found(found)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Insertion and Lookup (Key 5)", test_num);

        rst_n = 0; insert = 0; lookup = 0; key = 0;
        @(posedge clk); rst_n = 1; @(posedge clk);


        key = 5'd5;
        insert = 1;
        @(posedge clk);
        insert = 0;
        @(posedge clk);


        lookup = 1;
        key = 5'd5;
        @(posedge clk);

        #1;


        check_outputs(1'b1);
        lookup = 0;
        @(posedge clk);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Lookup Non-existent Key", test_num);

        rst_n = 0; insert = 0; lookup = 0; key = 0;
        @(posedge clk); rst_n = 1; @(posedge clk);


        key = 5'd12;
        lookup = 1;
        @(posedge clk);

        #1;


        check_outputs(1'b0);
        lookup = 0;
        @(posedge clk);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Behavior", test_num);

        rst_n = 0; insert = 0; lookup = 0; @(posedge clk); rst_n = 1; @(posedge clk);
        key = 5'd7; insert = 1; @(posedge clk); insert = 0;


        rst_n = 0; @(posedge clk); rst_n = 1; @(posedge clk);


        key = 5'd7;
        lookup = 1;
        @(posedge clk);

        #1;


        check_outputs(1'b0);
        lookup = 0;
        @(posedge clk);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Collision Handling (Keys 2 and 10)", test_num);

        rst_n = 0; insert = 0; lookup = 0; @(posedge clk); rst_n = 1; @(posedge clk);


        key = 5'd2; insert = 1; @(posedge clk);

        key = 5'd10; insert = 1; @(posedge clk);
        insert = 0;


        key = 5'd2;
        lookup = 1;
        @(posedge clk);

        #1;


        check_outputs(1'b1);
        lookup = 0;
        @(posedge clk);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Value (Key 31)", test_num);

        rst_n = 0; insert = 0; lookup = 0; @(posedge clk); rst_n = 1; @(posedge clk);


        key = 5'd31;
        insert = 1;
        @(posedge clk);
        insert = 0;


        lookup = 1;
        @(posedge clk);

        #1;


        check_outputs(1'b1);
        lookup = 0;
        @(posedge clk);
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
        input expected_found;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_found === (expected_found ^ found ^ expected_found)) begin
                $display("PASS");
                $display("  Outputs: found=%b",
                         found);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: found=%b",
                         expected_found);
                $display("  Got:      found=%b",
                         found);
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
