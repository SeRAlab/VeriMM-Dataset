`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data0;
    reg [15:0] data1;
    reg [15:0] data2;
    reg [15:0] data3;
    reg [15:0] data4;
    reg [15:0] data5;
    reg [1:0] op;
    reg [1:0] shop;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .op(op),
        .shop(shop),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data0 (op=00, shop=00)", test_num);
            data0 = 16'hA0A0; data1 = 16'hB1B1; data2 = 16'hC2C2;
            data3 = 16'hD3D3; data4 = 16'hE4E4; data5 = 16'hF5F5;
            op = 2'b00; shop = 2'b00;
            #1;

            check_outputs(16'hA0A0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data1 (op=00, shop=01)", test_num);
            data0 = 16'hA0A0; data1 = 16'hB1B1; data2 = 16'hC2C2;
            data3 = 16'hD3D3; data4 = 16'hE4E4; data5 = 16'hF5F5;
            op = 2'b00; shop = 2'b01;
            #1;

            check_outputs(16'hB1B1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data2 (op=00, shop=10)", test_num);
            data0 = 16'hA0A0; data1 = 16'hB1B1; data2 = 16'hC2C2;
            data3 = 16'hD3D3; data4 = 16'hE4E4; data5 = 16'hF5F5;
            op = 2'b00; shop = 2'b10;
            #1;

            check_outputs(16'hC2C2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data3 (op=00, shop=11)", test_num);
            data0 = 16'hA0A0; data1 = 16'hB1B1; data2 = 16'hC2C2;
            data3 = 16'hD3D3; data4 = 16'hE4E4; data5 = 16'hF5F5;
            op = 2'b00; shop = 2'b11;
            #1;

            check_outputs(16'hD3D3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data4 (op=01, shop=00)", test_num);
            data0 = 16'hA0A0; data1 = 16'hB1B1; data2 = 16'hC2C2;
            data3 = 16'hD3D3; data4 = 16'hE4E4; data5 = 16'hF5F5;
            op = 2'b01; shop = 2'b00;
            #1;

            check_outputs(16'hE4E4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data5 (op=01, shop=01)", test_num);
            data0 = 16'hA0A0; data1 = 16'hB1B1; data2 = 16'hC2C2;
            data3 = 16'hD3D3; data4 = 16'hE4E4; data5 = 16'hF5F5;
            op = 2'b01; shop = 2'b01;
            #1;

            check_outputs(16'hF5F5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dynamic data change on data0", test_num);
            op = 2'b00; shop = 2'b00;
            data0 = 16'h1234;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Out of range selection (op=11, shop=11)", test_num);
            data0 = 16'hAAAA;
            op = 2'b11; shop = 2'b11;

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
