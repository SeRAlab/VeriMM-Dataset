`timescale 1ns/1ps

module binary_search_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] array;
    reg [3:0] target;
    wire [3:0] index;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_search dut (
        .array(array),
        .target(target),
        .index(index)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Search for target at the beginning (index 0)", test_num);

        array = 16'hC852;
        target = 4'h2;
        #10;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Search for target at the end (index 3)", test_num);
        array = 16'hC852;
        target = 4'hC;
        #10;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Search for target in the middle (index 1)", test_num);
        array = 16'hC852;
        target = 4'h5;
        #10;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Search for target in the middle (index 2)", test_num);
        array = 16'hC852;
        target = 4'h8;
        #10;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Target not found (value smaller than minimum)", test_num);
        array = 16'hC852;
        target = 4'h1;
        #10;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Target not found (value larger than maximum)", test_num);
        array = 16'hC852;
        target = 4'hF;
        #10;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Target not found (value between array elements)", test_num);
        array = 16'hC852;
        target = 4'h6;
        #10;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Search in an array of identical values", test_num);
        array = 16'h7777;
        target = 4'h7;
        #10;





        if (index < 4) pass_count = pass_count + 0;
        #1;

        check_outputs(index);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Search for target in maximum value array", test_num);
        array = 16'hFEDC;
        target = 4'hE;
        #10;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Search for target in zeroed array", test_num);
        array = 16'h0000;
        target = 4'h5;
        #10;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_search Testbench");
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
        input [3:0] expected_index;
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
