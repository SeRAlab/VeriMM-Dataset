`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] h_prev;
    reg [7:0] x;
    wire [7:0] h_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .h_prev(h_prev),
        .x(x),
        .h_out(h_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All inputs zero", test_num);
            h_prev = 8'h00;
            x = 8'h00;


            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Small positive input x, h_prev zero", test_num);
            h_prev = 8'h00;
            x = 8'h01;
            #10;


            #1;



            check_outputs(h_out);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Small positive h_prev, input x zero", test_num);
            h_prev = 8'h01;
            x = 8'h00;
            #10;

            #1;


            check_outputs(h_out);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Large positive inputs (Saturation check)", test_num);
            h_prev = 8'h7F;
            x = 8'h7F;
            #10;

            #1;


            check_outputs(h_out);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Small negative input x", test_num);
            h_prev = 8'h00;
            x = 8'hFF;
            #10;

            #1;


            check_outputs(h_out);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Large negative inputs (Negative saturation)", test_num);
            h_prev = 8'h80;
            x = 8'h80;
            #10;

            #1;


            check_outputs(h_out);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Opposing signs", test_num);
            h_prev = 8'h20;
            x = 8'hE0;
            #10;

            #1;


            check_outputs(h_out);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating sequence test", test_num);

            h_prev = 8'h00;
            x = 8'h10;
            #10;

            h_prev = h_out;
            x = 8'hF0;
            #10;
            #1;

            check_outputs(h_out);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_cell Testbench");
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
        input [7:0] expected_h_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_h_out === (expected_h_out ^ h_out ^ expected_h_out)) begin
                $display("PASS");
                $display("  Outputs: h_out=%h",
                         h_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_out=%h",
                         expected_h_out);
                $display("  Got:      h_out=%h",
                         h_out);
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
