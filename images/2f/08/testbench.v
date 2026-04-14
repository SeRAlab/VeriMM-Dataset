`timescale 1ns/1ps

module decoder_5to32_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_5to32 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Testing Input 0", test_num);
            in = 5'd0;
            #10;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Testing Input 31 (Max Value)", test_num);
            in = 5'd31;
            #10;
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Testing Input 1", test_num);
            in = 5'd1;
            #10;
            #1;

            check_outputs(32'h0000_0002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Testing Input 16 (Mid Point)", test_num);
            in = 5'd16;
            #10;
            #1;

            check_outputs(32'h0001_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Testing Input 5", test_num);
            in = 5'd5;
            #10;
            #1;

            check_outputs(32'h0000_0020);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Testing Input 10", test_num);
            in = 5'd10;
            #10;
            #1;

            check_outputs(32'h0000_0400);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Testing Input 21", test_num);
            in = 5'd21;
            #10;
            #1;

            check_outputs(32'h0020_0000);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            $display("Test Case %0d: Comprehensive Sweep (Inputs 0 to 31)", test_num);
            for (i = 0; i < 32; i = i + 1) begin
                in = i;
                #5;
                #1;

                check_outputs(32'h1 << i);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_5to32 Testbench");
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
