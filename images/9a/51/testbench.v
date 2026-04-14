`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    reg [1:0] sel;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=00 (No extension, pass-through)", test_num);
            in = 32'h12345678;
            sel = 2'b00;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=01 (Byte extend, MSB in[7]=0)", test_num);
            in = 32'h0000007F;
            sel = 2'b01;
            #1;

            check_outputs(32'h0000007F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=01 (Byte extend, MSB in[7]=1)", test_num);
            in = 32'h00000080;
            sel = 2'b01;
            #1;

            check_outputs(32'hFFFFFF80);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=01 (Byte extend, discard upper bits)", test_num);
            in = 32'hAABBCC85;
            sel = 2'b01;
            #1;

            check_outputs(32'hFFFFFF85);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=10 (Half-word extend, MSB in[15]=0)", test_num);
            in = 32'h00007FFF;
            sel = 2'b10;
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=10 (Half-word extend, MSB in[15]=1)", test_num);
            in = 32'h00008000;
            sel = 2'b10;
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=10 (Half-word extend, discard upper bits)", test_num);
            in = 32'h1234A5A5;
            sel = 2'b10;
            #1;

            check_outputs(32'hFFFFA5A5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=11 (Default/No extension)", test_num);
            in = 32'hDEADBEEF;
            sel = 2'b11;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=01 (Byte extend, input=0xFFFFFFFF)", test_num);
            in = 32'hFFFFFFFF;
            sel = 2'b01;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=10 (Half-word extend, input=0x0000FFFF)", test_num);
            in = 32'h0000FFFF;
            sel = 2'b10;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_out;
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
