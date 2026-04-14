`timescale 1ns/1ps

module binary_xnor_gate_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] w;
    reg [1:0] z;
    wire [1:0] xnor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_xnor_gate dut (
        .w(w),
        .z(z),
        .xnor_out(xnor_out)
    );
    task testcase001;

        begin
            test_num = 1;
            z = 2'b00;
            w = 2'b00;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            z = 2'b11;
            w = 2'b11;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            z = 2'b00;
            w = 2'b11;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            z = 2'b10;
            w = 2'b10;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            z = 2'b10;
            w = 2'b01;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            z = 2'b11;
            w = 2'b10;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            z = 2'b00;
            w = 2'b10;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            z = 2'b01;
            w = 2'b11;
            #1;

            check_outputs(2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_xnor_gate Testbench");
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
        input [1:0] expected_xnor_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_xnor_out === (expected_xnor_out ^ xnor_out ^ expected_xnor_out)) begin
                $display("PASS");
                $display("  Outputs: xnor_out=%h",
                         xnor_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xnor_out=%h",
                         expected_xnor_out);
                $display("  Got:      xnor_out=%h",
                         xnor_out);
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
