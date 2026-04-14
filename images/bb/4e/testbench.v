`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] c;
    wire [6:0] out_or;
    wire [6:0] out_product;
    wire [7:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .out_or(out_or),
        .out_product(out_product),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = 1;
            c = 8'h00;
            #10;
            $display("Test Case %0d: All Zeros (c=0x00)", test_num);
            #1;

            check_outputs(7'h00, 7'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            c = 8'hFF;
            #10;
            $display("Test Case %0d: All Ones (c=0xFF)", test_num);



            #1;




            check_outputs(7'h7F, 7'h7E, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            c = 8'h55;
            #10;
            $display("Test Case %0d: Alternating 01010101 (c=0x55)", test_num);



            #1;




            check_outputs(7'h7F, 7'h00, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            c = 8'hAA;
            #10;
            $display("Test Case %0d: Alternating 10101010 (c=0xAA)", test_num);



            #1;




            check_outputs(7'h7F, 7'h00, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            c = 8'h01;
            #10;
            $display("Test Case %0d: Single Bit c[0] (c=0x01)", test_num);



            #1;




            check_outputs(7'h01, 7'h00, 8'h81);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            c = 8'h80;
            #10;
            $display("Test Case %0d: Single Bit c[7] (c=0x80)", test_num);



            #1;




            check_outputs(7'h40, 7'h00, 8'hC0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            c = 8'h36;
            #10;
            $display("Test Case %0d: Pattern 00110110 (c=0x36)", test_num);



            #1;




            check_outputs(7'h3F, 7'h24, 8'h2D);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            c = 8'h81;
            #10;
            $display("Test Case %0d: Wrap-around c[7] and c[0] (c=0x81)", test_num);



            #1;




            check_outputs(7'h41, 7'h00, 8'h41);
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
        input [6:0] expected_out_or;
        input [6:0] expected_out_product;
        input [7:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_product === (expected_out_product ^ out_product ^ expected_out_product) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_or=%h, out_product=%h, out_xor=%h",
                         out_or, out_product, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_or=%h, out_product=%h, out_xor=%h",
                         expected_out_or, expected_out_product, expected_out_xor);
                $display("  Got:      out_or=%h, out_product=%h, out_xor=%h",
                         out_or, out_product, out_xor);
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
