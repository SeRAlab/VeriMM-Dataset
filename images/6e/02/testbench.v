`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [254:0] in;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            in = 255'b0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones", test_num);
            in = {255{1'b1}};
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit set (LSB)", test_num);
            in = 255'b1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit set (MSB)", test_num);
            in = (255'b1 << 254);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (1010...)", test_num);


            in = {127{2'b10}, 1'b1};
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower 100 bits set", test_num);
            in = {{155{1'b0}}, {100{1'b1}}};
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 110 repeating", test_num);


            in = {85{3'b110}};
            #1;

            check_outputs(8'd170);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern mix", test_num);




            in = 255'b0;
            in[7:0] = 8'hFF;
            in[15:8] = 8'h0F;
            in[23:16] = 8'h55;
            #1;

            check_outputs(8'd16);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Midpoint bit set", test_num);
            in = (255'b1 << 127);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary segments", test_num);

            in = (255'b1 << 0) | (255'b1 << 32) | (255'b1 << 64) | (255'b1 << 96) |
                 (255'b1 << 128) | (255'b1 << 160) | (255'b1 << 192) | (255'b1 << 224);
            #1;

            check_outputs(8'd8);
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
