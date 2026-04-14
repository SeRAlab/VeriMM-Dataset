`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg [4:0] data_in;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .ctrl(ctrl),
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            $display("Test Case 001: Active Mode (ctrl=00), data_in=5'h1F");
            ctrl = 2'b00;
            data_in = 5'h1F;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Active Mode (ctrl=00), data_in=5'h0A");
            ctrl = 2'b00;
            data_in = 5'h0A;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Active Mode (ctrl=01), data_in=5'h15");
            ctrl = 2'b01;
            data_in = 5'h15;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Active Mode (ctrl=01), data_in=5'h00");
            ctrl = 2'b01;
            data_in = 5'h00;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Sleep Mode (ctrl=10), data_in=5'h1F");
            ctrl = 2'b10;
            data_in = 5'h1F;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Sleep Mode (ctrl=10), data_in=5'h05");
            ctrl = 2'b10;
            data_in = 5'h05;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Sleep Mode (ctrl=11), data_in=5'h12");
            ctrl = 2'b11;
            data_in = 5'h12;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Sleep Mode (ctrl=11), data_in=5'h00");
            ctrl = 2'b11;
            data_in = 5'h00;
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
        $display("power_gating Testbench");
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
        input [4:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
