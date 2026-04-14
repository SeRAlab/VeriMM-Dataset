`timescale 1ns/1ps

module mux4x1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data0;
    reg [7:0] data1;
    reg [7:0] data2;
    reg [7:0] data3;
    reg [1:0] selectInput;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4x1 dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .selectInput(selectInput),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            data0 = 8'hAA; data1 = 8'hBB; data2 = 8'hCC; data3 = 8'hDD;
            selectInput = 2'b00;
            $display("Test Case %0d: Selecting data0 (Expected: %h)", test_num, data0);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data0 = 8'h11; data1 = 8'h22; data2 = 8'h33; data3 = 8'h44;
            selectInput = 2'b01;
            $display("Test Case %0d: Selecting data1 (Expected: %h)", test_num, data1);
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data0 = 8'h0F; data1 = 8'hF0; data2 = 8'h55; data3 = 8'hAA;
            selectInput = 2'b10;
            $display("Test Case %0d: Selecting data2 (Expected: %h)", test_num, data2);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data0 = 8'hDE; data1 = 8'hAD; data2 = 8'hBE; data3 = 8'hEF;
            selectInput = 2'b11;
            $display("Test Case %0d: Selecting data3 (Expected: %h)", test_num, data3);
            #1;

            check_outputs(8'hEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data0 = 8'h00; data1 = 8'h00; data2 = 8'h00; data3 = 8'h00;
            selectInput = 2'b01;
            $display("Test Case %0d: All inputs Zero (Expected: 00)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data0 = 8'hFF; data1 = 8'hFF; data2 = 8'hFF; data3 = 8'hFF;
            selectInput = 2'b10;
            $display("Test Case %0d: All inputs FF (Expected: FF)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data0 = 8'h01; data1 = 8'h02; data2 = 8'h03; data3 = 8'h04;
            selectInput = 2'b00;
            #5;
            selectInput = 2'b11;
            $display("Test Case %0d: Switching select from 00 to 11 (Expected: 04)", test_num);
            #1;

            check_outputs(8'h04);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4x1 Testbench");
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
