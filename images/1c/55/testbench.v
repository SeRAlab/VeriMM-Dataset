`timescale 1ns/1ps

module monte_carlo_sim_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg [4:0] random_num;
    wire [4:0] output_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_sim dut (
        .ctrl(ctrl),
        .random_num(random_num),
        .output_num(output_num)
    );
    task testcase001;

        begin
            $display("Testcase 001: Ctrl=0, Inverting 0");
            ctrl = 1'b0;
            random_num = 5'd0;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Ctrl=0, Inverting 31");
            ctrl = 1'b0;
            random_num = 5'd31;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Ctrl=0, Inverting 10");
            ctrl = 1'b0;
            random_num = 5'd10;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Ctrl=1, Squaring 0");
            ctrl = 1'b1;
            random_num = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Ctrl=1, Squaring 5");
            ctrl = 1'b1;
            random_num = 5'd5;
            #1;

            check_outputs(5'd25);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Ctrl=1, Squaring 6 (Truncation check)");
            ctrl = 1'b1;
            random_num = 5'd6;


            #1;



            check_outputs(5'd4);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Ctrl=1, Squaring 31 (Max value truncation)");
            ctrl = 1'b1;
            random_num = 5'd31;


            #1;



            check_outputs(5'd1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Ctrl=1, Squaring 1");
            ctrl = 1'b1;
            random_num = 5'd1;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Ctrl=0, Inverting 15");
            ctrl = 1'b0;
            random_num = 5'd15;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("monte_carlo_sim Testbench");
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
        input [4:0] expected_output_num;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_num === (expected_output_num ^ output_num ^ expected_output_num)) begin
                $display("PASS");
                $display("  Outputs: output_num=%h",
                         output_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_num=%h",
                         expected_output_num);
                $display("  Got:      output_num=%h",
                         output_num);
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
