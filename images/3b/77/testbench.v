`timescale 1ns/1ps

module rs_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    wire [15:0] parity_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rs_encoder dut (
        .data_in(data_in),
        .parity_out(parity_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 32'h00000000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 32'h00000001;
            #1;

            check_outputs(16'h0302);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 32'h00000100;
            #1;

            check_outputs(16'h0706);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 32'h01000000;
            #1;

            check_outputs(16'h1F1E);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 32'h01020304;
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 32'hFFFFFFFF;
            #1;

            check_outputs(16'h9090);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 32'hAABBCCDD;
            #1;

            check_outputs(16'hA9A9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rs_encoder Testbench");
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
        input [15:0] expected_parity_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_parity_out === (expected_parity_out ^ parity_out ^ expected_parity_out)) begin
                $display("PASS");
                $display("  Outputs: parity_out=%h",
                         parity_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity_out=%h",
                         expected_parity_out);
                $display("  Got:      parity_out=%h",
                         parity_out);
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
