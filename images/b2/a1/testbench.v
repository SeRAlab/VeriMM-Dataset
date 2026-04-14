`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] ain;
    reg [15:0] bin;
    reg [15:0] cin;
    reg [15:0] din;
    reg [3:0] select;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ain(ain),
        .bin(bin),
        .cin(cin),
        .din(din),
        .select(select),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select ain (select=0)", test_num);
            ain = 16'hAAAA;
            bin = 16'h5555;
            cin = 16'h1234;
            din = 16'hF0F0;
            select = 4'd0;
            #10;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select bin (select=1)", test_num);
            ain = 16'hAAAA;
            bin = 16'h5555;
            cin = 16'h1234;
            din = 16'hF0F0;
            select = 4'd1;
            #10;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select cin (select=2)", test_num);
            ain = 16'hAAAA;
            bin = 16'h5555;
            cin = 16'h1234;
            din = 16'hF0F0;
            select = 4'd2;
            #10;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select din (select=3)", test_num);
            ain = 16'hAAAA;
            bin = 16'h5555;
            cin = 16'h1234;
            din = 16'hF0F0;
            select = 4'd3;
            #10;
            #1;

            check_outputs(16'hF0F0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs same value", test_num);
            ain = 16'hFFFF;
            bin = 16'hFFFF;
            cin = 16'hFFFF;
            din = 16'hFFFF;
            select = 4'd1;
            #10;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input change while selected", test_num);
            ain = 16'h0000;
            bin = 16'h1111;
            cin = 16'h2222;
            din = 16'h3333;
            select = 4'd0;
            #5;
            ain = 16'hBEEF;
            #5;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select zero value", test_num);
            ain = 16'hFFFF;
            bin = 16'h0000;
            cin = 16'hFFFF;
            din = 16'hFFFF;
            select = 4'd1;
            #10;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_out;
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
