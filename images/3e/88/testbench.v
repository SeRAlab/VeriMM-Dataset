`timescale 1ns/1ps

module hmac_simple_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] key;
    reg [7:0] message;
    wire [7:0] hmac_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac_simple dut (
        .key(key),
        .message(message),
        .hmac_out(hmac_out)
    );
    task testcase001;

        begin
            test_num = 1;
            key = 8'h00;
            message = 8'h00;

            #1;


            check_outputs(8'h36);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            key = 8'h00;
            message = 8'h01;

            #1;


            check_outputs(8'h37);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            key = 8'h01;
            message = 8'h00;

            #1;


            check_outputs(8'h37);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            key = 8'hFF;
            message = 8'hFF;

            #1;


            check_outputs(8'hC8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            key = 8'h55;
            message = 8'hAA;

            #1;


            check_outputs(8'h0D);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            key = 8'hAA;
            message = 8'h55;

            #1;


            check_outputs(8'hF1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            key = 8'h12;
            message = 8'h34;

            #1;


            check_outputs(8'h58);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            key = 8'h36;
            message = 8'h10;

            #1;


            check_outputs(8'h10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac_simple Testbench");
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
        input [7:0] expected_hmac_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hmac_out === (expected_hmac_out ^ hmac_out ^ expected_hmac_out)) begin
                $display("PASS");
                $display("  Outputs: hmac_out=%h",
                         hmac_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac_out=%h",
                         expected_hmac_out);
                $display("  Got:      hmac_out=%h",
                         hmac_out);
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
