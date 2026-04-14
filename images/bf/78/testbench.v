`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] address;
    reg ce;
    reg read_en;
    wire [7:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .ce(ce),
        .read_en(read_en),
        .data(data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read Address 0 (Enabled)", test_num);
            address = 4'd0;
            ce = 1'b1;
            read_en = 1'b1;
            #10;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read Address 5 (Enabled)", test_num);
            address = 4'd5;
            ce = 1'b1;
            read_en = 1'b1;
            #10;

            #1;


            check_outputs(8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read Address 10 (Enabled)", test_num);
            address = 4'd10;
            ce = 1'b1;
            read_en = 1'b1;
            #10;

            #1;


            check_outputs(8'h0a);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read Address 15 (Enabled - Boundary Test)", test_num);
            address = 4'd15;
            ce = 1'b1;
            read_en = 1'b1;
            #10;

            #1;


            check_outputs(8'h0f);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Chip Enable (ce) De-asserted", test_num);
            address = 4'd7;
            ce = 1'b0;
            read_en = 1'b1;
            #10;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read Enable (read_en) De-asserted", test_num);
            address = 4'd3;
            ce = 1'b1;
            read_en = 1'b0;
            #10;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Both Control Signals De-asserted", test_num);
            address = 4'd12;
            ce = 1'b0;
            read_en = 1'b0;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dynamic Address Change while Enabled", test_num);
            ce = 1'b1;
            read_en = 1'b1;
            address = 4'd2;
            #10;
            address = 4'd9;
            #10;

            #1;


            check_outputs(8'h09);
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
        input [7:0] expected_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
