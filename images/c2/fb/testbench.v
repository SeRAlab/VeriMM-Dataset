`timescale 1ns/1ps

module shift_add_xor_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_add_xor dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 32'h00000000;
            #10;

            #1;


            check_outputs((({32'h0, in} << 4) + 64'h12345678) ^ KEY);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 32'h00000001;
            #10;

            #1;


            check_outputs((({32'h0, in} << 4) + 64'h12345678) ^ KEY);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 32'hFFFFFFFF;
            #10;
            #1;

            check_outputs((({32'h0, in} << 4) + 64'h12345678) ^ KEY);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 32'h12345678;
            #10;
            #1;

            check_outputs((({32'h0, in} << 4) + 64'h12345678) ^ KEY);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 32'h80000000;
            #10;
            #1;

            check_outputs((({32'h0, in} << 4) + 64'h12345678) ^ KEY);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_add_xor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [63:0] expected_out;
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
