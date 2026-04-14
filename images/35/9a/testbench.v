`timescale 1ns/1ps

module binary_max_heap_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg [2:0] index;
    reg insert;
    wire [7:0] max_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_max_heap dut (
        .data_in(data_in),
        .index(index),
        .insert(insert),
        .max_out(max_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Mixed Value Insertion");

            insert = 0; data_in = 8'd0; index = 3'd0; #10;


            data_in = 8'd45; index = 3'd0; insert = 1; #10; insert = 0; #10;
            data_in = 8'd22; index = 3'd1; insert = 1; #10; insert = 0; #10;
            data_in = 8'd99; index = 3'd2; insert = 1; #10; insert = 0; #10;
            data_in = 8'd12; index = 3'd3; insert = 1; #10; insert = 0; #10;
            data_in = 8'd78; index = 3'd4; insert = 1; #10; insert = 0; #10;
            data_in = 8'd34; index = 3'd5; insert = 1; #10; insert = 0; #10;
            data_in = 8'd56; index = 3'd6; insert = 1; #10; insert = 0; #10;
            data_in = 8'd01; index = 3'd7; insert = 1; #10; insert = 0; #10;


            #1;



            check_outputs(8'd99);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case 002: Strictly Increasing Sequence");
            insert = 0; data_in = 8'd0; index = 3'd0; #10;

            for (i = 0; i < 8; i = i + 1) begin
                data_in = (i + 1) * 10;
                index = i[2:0];
                insert = 1; #10; insert = 0; #10;
            end


            #1;



            check_outputs(8'd80);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case 003: Strictly Decreasing Sequence");
            insert = 0; data_in = 8'd0; index = 3'd0; #10;

            for (i = 0; i < 8; i = i + 1) begin
                data_in = 8'd100 - (i * 10);
                index = i[2:0];
                insert = 1; #10; insert = 0; #10;
            end


            #1;



            check_outputs(8'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Replacing Root (Bubble-down check)");
            insert = 0; data_in = 8'd0; index = 3'd0; #10;


            data_in = 8'd100; index = 3'd0; insert = 1; #10; insert = 0; #10;
            data_in = 8'd90;  index = 3'd1; insert = 1; #10; insert = 0; #10;
            data_in = 8'd85;  index = 3'd2; insert = 1; #10; insert = 0; #10;

            data_in = 8'd10;
            index = 3; insert = 1; #10; insert = 0; #10;
            index = 4; insert = 1; #10; insert = 0; #10;
            index = 5; insert = 1; #10; insert = 0; #10;
            index = 6; insert = 1; #10; insert = 0; #10;
            index = 7; insert = 1; #10; insert = 0; #10;


            data_in = 8'd50; index = 3'd0; insert = 1; #10; insert = 0; #10;


            #1;



            check_outputs(8'd90);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case 005: Boundary Values");
            insert = 0; data_in = 8'd0; index = 3'd0; #10;


            for (i = 0; i < 8; i = i + 1) begin
                data_in = 8'd0; index = i[2:0]; insert = 1; #10; insert = 0; #10;
            end


            data_in = 8'd255; index = 3'd7; insert = 1; #10; insert = 0; #10;


            #1;



            check_outputs(8'd255);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_max_heap Testbench");
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
        input [7:0] expected_max_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max_out === (expected_max_out ^ max_out ^ expected_max_out)) begin
                $display("PASS");
                $display("  Outputs: max_out=%h",
                         max_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_out=%h",
                         expected_max_out);
                $display("  Got:      max_out=%h",
                         max_out);
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
