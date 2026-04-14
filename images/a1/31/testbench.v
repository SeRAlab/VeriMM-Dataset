`timescale 1ns/1ps

module binary_decoder_8to256_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [255:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_decoder_8to256 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Testing input 8'h00 (Minimum value)", test_num);
            in = 8'h00;
            #1;

            check_outputs(256'b1 << 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Testing input 8'hFF (Maximum value)", test_num);
            in = 8'hFF;
            #1;

            check_outputs(256'b1 << 255);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Testing input 8'h01", test_num);
            in = 8'h01;
            #1;

            check_outputs(256'b1 << 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Testing input 8'h80 (Midpoint start)", test_num);
            in = 8'h80;
            #1;

            check_outputs(256'b1 << 128);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Testing input 8'h7F (Midpoint end)", test_num);
            in = 8'h7F;
            #1;

            check_outputs(256'b1 << 127);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Testing input 8'hAA (Alternating pattern 1)", test_num);
            in = 8'hAA;
            #1;

            check_outputs(256'b1 << 170);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Testing input 8'h55 (Alternating pattern 2)", test_num);
            in = 8'h55;
            #1;

            check_outputs(256'b1 << 85);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Testing input 8'hF0", test_num);
            in = 8'hF0;
            #1;

            check_outputs(256'b1 << 240);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Testing input 8'h0F", test_num);
            in = 8'h0F;
            #1;

            check_outputs(256'b1 << 15);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Testing input 8'hC8", test_num);
            in = 8'hC8;
            #1;

            check_outputs(256'b1 << 200);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_decoder_8to256 Testbench");
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
        input [255:0] expected_out;
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
