`timescale 1ns/1ps

module SignExt_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SignExt dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Zero (16'h0000)", test_num);
            in = 16'h0000;
            #100;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Small Value (16'h0001)", test_num);
            in = 16'h0001;
            #100;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Positive (16'h7FFF)", test_num);
            in = 16'h7FFF;
            #100;
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Min Negative (16'h8000)", test_num);
            in = 16'h8000;
            #100;
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones (16'hFFFF)", test_num);
            in = 16'hFFFF;
            #100;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Random Value (16'hABCD)", test_num);
            in = 16'hABCD;
            #100;
            #1;

            check_outputs(32'hFFFFABCD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Random Value (16'h1234)", test_num);
            in = 16'h1234;
            #100;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SignExt Testbench");
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
