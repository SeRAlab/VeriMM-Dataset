`timescale 1ns/1ps

module noise_suppression_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] signal_in;
    wire [4:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    noise_suppression dut (
        .signal_in(signal_in),
        .signal_out(signal_out)
    );
    task testcase001;

        begin
            test_num = 1;
            signal_in = 5'b00000;


            #1;



            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            signal_in = 5'b00001;


            #1;



            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            signal_in = 5'b00011;


            #1;



            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            signal_in = 5'b00111;


            #1;



            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            signal_in = 5'b01111;


            #1;



            check_outputs(5'b11111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            signal_in = 5'b11111;


            #1;



            check_outputs(5'b11111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            signal_in = 5'b10101;


            #1;



            check_outputs(5'b11111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            signal_in = 5'b01010;


            #1;



            check_outputs(5'b00000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            signal_in = 5'b11011;


            #1;



            check_outputs(5'b11111);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            signal_in = 5'b00100;


            #1;



            check_outputs(5'b00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("noise_suppression Testbench");
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
        input [4:0] expected_signal_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%h",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%h",
                         expected_signal_out);
                $display("  Got:      signal_out=%h",
                         signal_out);
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
