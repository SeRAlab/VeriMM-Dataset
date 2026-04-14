`timescale 1ns/1ps

module even_parity_generator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire parity_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    even_parity_generator dut (
        .data_in(data_in),
        .parity_out(parity_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 4'b0000;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 4'b0001;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 4'b0010;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 4'b0011;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 4'b0100;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 4'b0101;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 4'b0110;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 4'b0111;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data_in = 4'b1000;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data_in = 4'b1001;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            data_in = 4'b1010;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            data_in = 4'b1011;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            data_in = 4'b1100;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            data_in = 4'b1101;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            data_in = 4'b1110;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            data_in = 4'b1111;
            $display("Testcase %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("even_parity_generator Testbench");
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_parity_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_parity_out === (expected_parity_out ^ parity_out ^ expected_parity_out)) begin
                $display("PASS");
                $display("  Outputs: parity_out=%b",
                         parity_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity_out=%b",
                         expected_parity_out);
                $display("  Got:      parity_out=%b",
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
